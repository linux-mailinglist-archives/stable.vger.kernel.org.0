Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF71A9E02
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409490AbgDOLtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:49:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38699 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409480AbgDOLtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:49:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D8AC75C0148;
        Wed, 15 Apr 2020 07:49:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yuMsg+
        g5YIJVl9EzA0STyHd+wbcg46mQI14iOXy1qs0=; b=Rpsy2yFX0c0nv7+eU2KmYx
        jZ70uzlAgxAhtdXjM4wxo/2Suxf2DhkPy5Mj6pR5OwU3RYk7tOnMiRWExLDAHljw
        8EtTGusSYcmw6lvA5H5WSjDDOmYOJr5FJkRmBEB6eCFqMOMXp1tt+NZXVmk5UsZv
        Q5jGpwpmhaRoYB2flc8Hum/v+1JbkuDUa/PSrgCAmYFMRhwWWs03hgGGDcRhOplr
        g7AoCiQ8SwBSRqqwLTJnVfDPRwZezDQUxaO6jJzs6mqUyjKqb+2Ujw2BboZtmYxg
        jnqk2r6GAf6xjtfor6IraT3icPrF+xEqH2CFuAi2kXQ7cipBk2+QWi01OdmOai1A
        ==
X-ME-Sender: <xms:uPSWXjpjm78uV5R_Mfb-vZgaLHP0p8yQmTYa2NxDIUAdfx7EcZQzeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:uPSWXgCCOdmv0KDcsJUKeYmDcODna_KzffNqkMqt221P__z4t4Gq4g>
    <xmx:uPSWXpdb2_mr0LiFd0661ebH7JAUotAjqQ-eEcfijLpeZX1j_cVfpA>
    <xmx:uPSWXqBUpGN67yOdypICNpbN2IboQcq89MSxdD3mXi7a3rdtpg7GGw>
    <xmx:uPSWXsv7NddJzeIb8Skgre32LkGAmvGnXQXl7VTY9-X9_y5byVLOPg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AF79328005E;
        Wed, 15 Apr 2020 07:49:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ipmi: fix hung processes in __get_guid()" failed to apply to 4.4-stable tree
To:     wenyang@linux.alibaba.com, arnd@arndb.de, cminyard@mvista.com,
        gregkh@linuxfoundation.org, minyard@acm.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:49:09 +0200
Message-ID: <158695134974133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 32830a0534700f86366f371b150b17f0f0d140d7 Mon Sep 17 00:00:00 2001
From: Wen Yang <wenyang@linux.alibaba.com>
Date: Fri, 3 Apr 2020 17:04:08 +0800
Subject: [PATCH] ipmi: fix hung processes in __get_guid()

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

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 64ba16dcb681..c48d8f086382 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3193,8 +3193,8 @@ static void __get_guid(struct ipmi_smi *intf)
 	if (rv)
 		/* Send failed, no GUID available. */
 		bmc->dyn_guid_set = 0;
-
-	wait_event(intf->waitq, bmc->dyn_guid_set != 2);
+	else
+		wait_event(intf->waitq, bmc->dyn_guid_set != 2);
 
 	/* dyn_guid_set makes the guid data available. */
 	smp_rmb();

