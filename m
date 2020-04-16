Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8843F1ACA4E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634200AbgDPPdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898275AbgDPNlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:41:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3793D20732;
        Thu, 16 Apr 2020 13:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044473;
        bh=x88x2MROQSuasxIps+Xd6wS0fxFRe6Oh0oZV5yoekJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlThskKRTMsg/uUydlpgtXeDRSECX+LHeyYjMESP7SF3lFtQDHrAQpOzxy91o4Qa6
         RURMDRTCZJ+snwiz1pA0e38AVMx+Hr63bDFKVTnNC1Co+A+YNC7FiGbPy8ExI++Dfx
         yuTevCQsBxJ/BRCzWDttVkvK4pkdMSxLFB8+4ODc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 232/257] libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DFLAG_DETACH is set
Date:   Thu, 16 Apr 2020 15:24:43 +0200
Message-Id: <20200416131354.691542527@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 8305f72f952cff21ce8109dc1ea4b321c8efc5af upstream.

During system resume from suspend, this can be observed on ASM1062 PMP
controller:

ata10.01: SATA link down (SStatus 0 SControl 330)
ata10.02: hard resetting link
ata10.02: SATA link down (SStatus 0 SControl 330)
ata10.00: configured for UDMA/133
Kernel panic - not syncing: stack-protector: Kernel
 in: sata_pmp_eh_recover+0xa2b/0xa40

CPU: 2 PID: 230 Comm: scsi_eh_9 Tainted: P OE
#49-Ubuntu
Hardware name: System manufacturer System Product
 1001 12/10/2017
Call Trace:
dump_stack+0x63/0x8b
panic+0xe4/0x244
? sata_pmp_eh_recover+0xa2b/0xa40
__stack_chk_fail+0x19/0x20
sata_pmp_eh_recover+0xa2b/0xa40
? ahci_do_softreset+0x260/0x260 [libahci]
? ahci_do_hardreset+0x140/0x140 [libahci]
? ata_phys_link_offline+0x60/0x60
? ahci_stop_engine+0xc0/0xc0 [libahci]
sata_pmp_error_handler+0x22/0x30
ahci_error_handler+0x45/0x80 [libahci]
ata_scsi_port_error_handler+0x29b/0x770
? ata_scsi_cmd_error_handler+0x101/0x140
ata_scsi_error+0x95/0xd0
? scsi_try_target_reset+0x90/0x90
scsi_error_handler+0xd0/0x5b0
kthread+0x121/0x140
? scsi_eh_get_sense+0x200/0x200
? kthread_create_worker_on_cpu+0x70/0x70
ret_from_fork+0x22/0x40
Kernel Offset: 0xcc00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Since sata_pmp_eh_recover_pmp() doens't set rc when ATA_DFLAG_DETACH is
set, sata_pmp_eh_recover() continues to run. During retry it triggers
the stack protector.

Set correct rc in sata_pmp_eh_recover_pmp() to let sata_pmp_eh_recover()
jump to pmp_fail directly.

BugLink: https://bugs.launchpad.net/bugs/1821434
Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-pmp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -763,6 +763,7 @@ static int sata_pmp_eh_recover_pmp(struc
 
 	if (dev->flags & ATA_DFLAG_DETACH) {
 		detach = 1;
+		rc = -ENODEV;
 		goto fail;
 	}
 


