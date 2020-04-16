Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8871AC662
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgDPOir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409647AbgDPOC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9761F2078B;
        Thu, 16 Apr 2020 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045746;
        bh=vZKMLH6+87IUjMNrup5IggY1o+3zzdiZAgU3UikVZlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owGHh+LpTJdhAAMlyPBDyUdeEMuuxUMF8KXFiu7emx/nYXbCY6jIbrI9PYlt3DBEY
         Aa3JOPvRqT59vdgiKiAQ0iEQbIurD5VABX6jymoyni14a5GD09bOOtyVEheONwAZId
         SxaR/jeUCRgUddAUFbNiC1DfMZq6Lwp4M7PRtmhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Corey Minyard <minyard@acm.org>, Arnd Bergmann <arnd@arndb.de>,
        openipmi-developer@lists.sourceforge.net,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.6 232/254] ipmi: fix hung processes in __get_guid()
Date:   Thu, 16 Apr 2020 15:25:21 +0200
Message-Id: <20200416131354.620404362@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

commit 32830a0534700f86366f371b150b17f0f0d140d7 upstream.

The wait_event() function is used to detect command completion.
When send_guid_cmd() returns an error, smi_send() has not been
called to send data. Therefore, wait_event() should not be used
on the error path, otherwise it will cause the following warning:

[ 1361.588808] systemd-udevd   D    0  1501   1436 0x00000004
[ 1361.588813]  ffff883f4b1298c0 0000000000000000 ffff883f4b188000 ffff887f7e3d9f40
[ 1361.677952]  ffff887f64bd4280 ffffc90037297a68 ffffffff8173ca3b ffffc90000000010
[ 1361.767077]  00ffc90037297ad0 ffff887f7e3d9f40 0000000000000286 ffff883f4b188000
[ 1361.856199] Call Trace:
[ 1361.885578]  [<ffffffff8173ca3b>] ? __schedule+0x23b/0x780
[ 1361.951406]  [<ffffffff8173cfb6>] schedule+0x36/0x80
[ 1362.010979]  [<ffffffffa071f178>] get_guid+0x118/0x150 [ipmi_msghandler]
[ 1362.091281]  [<ffffffff810d5350>] ? prepare_to_wait_event+0x100/0x100
[ 1362.168533]  [<ffffffffa071f755>] ipmi_register_smi+0x405/0x940 [ipmi_msghandler]
[ 1362.258337]  [<ffffffffa0230ae9>] try_smi_init+0x529/0x950 [ipmi_si]
[ 1362.334521]  [<ffffffffa022f350>] ? std_irq_setup+0xd0/0xd0 [ipmi_si]
[ 1362.411701]  [<ffffffffa0232bd2>] init_ipmi_si+0x492/0x9e0 [ipmi_si]
[ 1362.487917]  [<ffffffffa0232740>] ? ipmi_pci_probe+0x280/0x280 [ipmi_si]
[ 1362.568219]  [<ffffffff810021a0>] do_one_initcall+0x50/0x180
[ 1362.636109]  [<ffffffff812231b2>] ? kmem_cache_alloc_trace+0x142/0x190
[ 1362.714330]  [<ffffffff811b2ae1>] do_init_module+0x5f/0x200
[ 1362.781208]  [<ffffffff81123ca8>] load_module+0x1898/0x1de0
[ 1362.848069]  [<ffffffff811202e0>] ? __symbol_put+0x60/0x60
[ 1362.913886]  [<ffffffff8130696b>] ? security_kernel_post_read_file+0x6b/0x80
[ 1362.998514]  [<ffffffff81124465>] SYSC_finit_module+0xe5/0x120
[ 1363.068463]  [<ffffffff81124465>] ? SYSC_finit_module+0xe5/0x120
[ 1363.140513]  [<ffffffff811244be>] SyS_finit_module+0xe/0x10
[ 1363.207364]  [<ffffffff81003c04>] do_syscall_64+0x74/0x180

Fixes: 50c812b2b951 ("[PATCH] ipmi: add full sysfs support")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: openipmi-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 2.6.17-
Message-Id: <20200403090408.58745-1-wenyang@linux.alibaba.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_msghandler.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3188,8 +3188,8 @@ static void __get_guid(struct ipmi_smi *
 	if (rv)
 		/* Send failed, no GUID available. */
 		bmc->dyn_guid_set = 0;
-
-	wait_event(intf->waitq, bmc->dyn_guid_set != 2);
+	else
+		wait_event(intf->waitq, bmc->dyn_guid_set != 2);
 
 	/* dyn_guid_set makes the guid data available. */
 	smp_rmb();


