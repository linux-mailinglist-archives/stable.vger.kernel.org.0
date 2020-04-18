Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795D81AF01D
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgDROry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbgDROoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:44:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5192072B;
        Sat, 18 Apr 2020 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221039;
        bh=UMlaP/NeGsbjNpFWIDP5Jdm0OEQJeTjnAjNiEBovdZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzHDOkIi1c+CvxcKYimCl/imYqvO+e8Og4qqEk5IFgMDZh6xYzlalPIXYx2x3zIfU
         m0TFij5GfYczxQV2Z17OLXv6Hs57bvL2OPGpOB1LSmIWT3JMJf80VKFqsWRk445Qj0
         JsPGZGyLlfmX6LgBzmvgGJaYTI6VPqL0RmisBSE4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/28] libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DFLAG_DETACH is set
Date:   Sat, 18 Apr 2020 10:43:24 -0400
Message-Id: <20200418144328.10265-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144328.10265-1-sashal@kernel.org>
References: <20200418144328.10265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 8305f72f952cff21ce8109dc1ea4b321c8efc5af ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-pmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 85aa76116a305..7924d0635718d 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -764,6 +764,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 
 	if (dev->flags & ATA_DFLAG_DETACH) {
 		detach = 1;
+		rc = -ENODEV;
 		goto fail;
 	}
 
-- 
2.20.1

