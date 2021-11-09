Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379E544B8A2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345165AbhKIWpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345024AbhKIWmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:42:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A227461B3B;
        Tue,  9 Nov 2021 22:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496651;
        bh=AUBpS3ubOHiAhI5sJh5pGe9SIkaMFAgSqepsC0LcDGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doEVSTiqg29N9b/0k21r9dN5IlX7XRcxdE9NhtPiLPAsjVQvee3iJd0pwbkCcyMR1
         8BQKfGRwq0ghyvs7YELxa6Z55IbF6zT4oKi/OCfwUMYC9tt7iqxO+QZtTipqZqsU48
         ytatJAYLycNjxy1S3lFysNA5FX8yHVKyGJATN2FNgHQD3uXF7XX4yHMDWFbzq5JNNo
         jJPhC2Jo7JxWr+3VdYNjlAJFMo1lvEIcqu+O/co8z01OfOE9soCVqI5j7o8rxbg8L/
         EBS7MsS8GCEx1vgUe87FYAlj4KhvwDamWuTa6YN1HoUYLfXID+Fp7y/Ayk9+Ufh675
         lxGMLru3qBHKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, matthew@wil.cx, hare@suse.com,
        JBottomley@odin.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/13] scsi: advansys: Fix kernel pointer leak
Date:   Tue,  9 Nov 2021 17:23:55 -0500
Message-Id: <20211109222405.1236040-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222405.1236040-1-sashal@kernel.org>
References: <20211109222405.1236040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Zhi <qtxuning1999@sjtu.edu.cn>

[ Upstream commit d4996c6eac4c81b8872043e9391563f67f13e406 ]

Pointers should be printed with %p or %px rather than cast to 'unsigned
long' and printed with %lx.

Change %lx to %p to print the hashed pointer.

Link: https://lore.kernel.org/r/20210929122538.1158235-1-qtxuning1999@sjtu.edu.cn
Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 24e57e770432b..6efd17692a55a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3370,8 +3370,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		   shost->host_no);
 
 	seq_printf(m,
-		   " iop_base 0x%lx, cable_detect: %X, err_code %u\n",
-		   (unsigned long)v->iop_base,
+		   " iop_base 0x%p, cable_detect: %X, err_code %u\n",
+		   v->iop_base,
 		   AdvReadWordRegister(iop_base,IOPW_SCSI_CFG1) & CABLE_DETECT,
 		   v->err_code);
 
-- 
2.33.0

