Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4672444B8BD
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346222AbhKIWpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346106AbhKIWnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D909761A3C;
        Tue,  9 Nov 2021 22:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496671;
        bh=AUBpS3ubOHiAhI5sJh5pGe9SIkaMFAgSqepsC0LcDGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/T4x9LdI7hhLh6ocolekQmEAyuWablTmbf9zLPb9RmOZGFDCKSG+e1GKgZWlgFc9
         6mHhEYl1K4Uq042vOBDqIVpEENKaGNCutlt5MQ0B9MDWX0qfknnXTC2iHo3orRotX9
         oH4iPs8l1jBb/IRzsJqAiZ3OK3VBcxAf/d32U8yGdZd8QfvX4mZA17zil7nxZ2X/xl
         Cdfht2yWqmuDeVrGNYMw4B1ROJp83B4pTSQ0JzDgd4hgFdp7ZFCLHUW7JTDUuSbuOu
         UwAr7IgcubSs29h+7BOVRKwXZx71iCuN1nW0OqlXFGahOsIYuq3tjOTZgpRPJUfyy1
         T7XOrPf73uapA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, matthew@wil.cx, hare@suse.com,
        JBottomley@odin.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/12] scsi: advansys: Fix kernel pointer leak
Date:   Tue,  9 Nov 2021 17:24:17 -0500
Message-Id: <20211109222426.1236575-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222426.1236575-1-sashal@kernel.org>
References: <20211109222426.1236575-1-sashal@kernel.org>
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

