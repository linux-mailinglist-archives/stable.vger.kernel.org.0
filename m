Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49FD44B7FD
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344525AbhKIWj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345401AbhKIWh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:37:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B66619FA;
        Tue,  9 Nov 2021 22:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496570;
        bh=mr5m1kRKNtM8q/hm5ZR5bqjCDDynuR6Dkjet3knk2ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+2K4g3VA8SMj8RDmkPeTX4T8uQOLO3rSKRVvcEISeIH6iv9bzgJuDxkLSmAGditL
         TCDDEV1urgjNTJp5apav2imDSw/5n2qsjxWvg2/SE++cJVONdoyDV5nOZD3WW/wTmB
         CuLZYWq3IHfd3HO/xkJg8G6jMWdisUsJ1VycYELZDxtFKyKopzReJSqhbbdgzhcatO
         Y2x/VlMthqT2tYAjhDivNu5KbYooRsoDEnDx+hlUzUpRt94UuDGsT7Xv15hc+NC0oq
         2DjcmRWuCZV81Yx+uDb27y5SNXQGkguR2gSSOXEU34TdnPepZ6wE80ksXMNwGtTcSf
         VgtmdMOnVB90Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, matthew@wil.cx, hare@suse.com,
        JBottomley@odin.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/30] scsi: advansys: Fix kernel pointer leak
Date:   Tue,  9 Nov 2021 17:22:10 -0500
Message-Id: <20211109222224.1235388-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
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
index a242a62caaa16..7b3e52ff5f516 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3366,8 +3366,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
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

