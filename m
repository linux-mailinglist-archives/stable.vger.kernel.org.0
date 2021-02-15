Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E731BD1D
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhBOPkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231514AbhBOPhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAB2064EAD;
        Mon, 15 Feb 2021 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403215;
        bh=oottzwMwE9LU5zEDtqqbkNl1S94kxsMjf4g8+8diCFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjNehNTIALh+x//I7m+inkOZOuGzStpctJL316m4wfzEA2Mpl16cswOsO+KoGZHb0
         ZCsVYPiwOYvhtz4FzIjHyjFaYt4gUoC/CWS4YccaMVCjStr9wTFq85IMHAqox8UpXU
         GODl5BC5rSsPWZPxSxzno8LBwcoUAqSFDyvgycVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/104] scsi: scsi_debug: Fix a memory leak
Date:   Mon, 15 Feb 2021 16:27:23 +0100
Message-Id: <20210215152721.720212090@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f852c596f2ee6f0eb364ea8f28f89da6da0ae7b5 ]

The sdebug_q_arr pointer must be freed when the module is unloaded.

$ cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff888e1cfb0000 (size 4096):
  comm "modprobe", pid 165555, jiffies 4325987516 (age 685.194s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000458f4f5d>] 0xffffffffc06702d9
    [<000000003edc4b1f>] do_one_initcall+0xe9/0x57d
    [<00000000da7d518c>] do_init_module+0x1d1/0x6f0
    [<000000009a6a9248>] load_module+0x36bd/0x4f50
    [<00000000ddb0c3ce>] __do_sys_init_module+0x1db/0x260
    [<000000009532db57>] do_syscall_64+0xa5/0x420
    [<000000002916b13d>] entry_SYSCALL_64_after_hwframe+0x6a/0xdf

Fixes: 87c715dcde63 ("scsi: scsi_debug: Add per_host_store option")
Link: https://lore.kernel.org/r/20210208111734.34034-1-mlombard@redhat.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4a08c450b756f..b6540b92f5661 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6881,6 +6881,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	kfree(sdebug_q_arr);
 }
 
 device_initcall(scsi_debug_init);
-- 
2.27.0



