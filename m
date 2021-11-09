Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AE644B84B
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344220AbhKIWly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345022AbhKIWjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4515C61B2C;
        Tue,  9 Nov 2021 22:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496608;
        bh=K/XMC/1eGJD8Ny3WM6Yf8Gse2GhSI96Vpk6Ju+DMte8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO0Nyjh28O7hi6pWxX7+i6cTGU184ODvMrPC1p9t+P06jqe/I17ChFBadgcx0serT
         8Cgjk0WNXZRehII4bEkvHufu8g098xEbT0Scb02wcyaYGAb7AYhUzk3lZHZX7FirS7
         F9LMiXgmrwHUSF/AHuR+naF5V9Q8mWVNjDi0B5kCLup11q+4Kbp9/xuxqRUbFFiujx
         tmUlmEMEwrOhMIsGzi1C3M8XpKSoo/FoqgJbMFxORtnSCur1WnePz+PR6ZhH8k4tha
         NALR3sGBZG+VF2g0a77jTve4+ejAeiQLWntOFhwEhPG+GnSGxYCyntnZEjt28gG6x5
         uVZZVBQPye5iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, matthew@wil.cx, hare@suse.com,
        JBottomley@odin.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/21] scsi: advansys: Fix kernel pointer leak
Date:   Tue,  9 Nov 2021 17:22:59 -0500
Message-Id: <20211109222311.1235686-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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
index 713f69033f201..2856b0ce7ab9a 100644
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

