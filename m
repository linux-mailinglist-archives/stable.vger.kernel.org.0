Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002EF44B5BF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343580AbhKIWWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343579AbhKIWVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11AE619BB;
        Tue,  9 Nov 2021 22:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496282;
        bh=ZBIK6J5npJcrFTkgN975QVvI6xgANw5+dvbOmoJvGJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hoxc++sNYNCDbDunWF0hYkJXWnwVZ291ksJTwRZeBu3ujE7zaFvyVdswfkQCE+Wv+
         K78md6qthqw8F+RNupjXhp/L0gNh+zOLm29NKfYi8Pz2HivvKCF2Kb3JiMTlbGEsKr
         XDqoxHSOJZRS/CczplrmqucqYTHtgurqTKOdSiFFRdHD4W/6gaeo6ZIcNSp/vqQ1dc
         gve3RVtwuD7C/1hC0JwgTj95QVqjourmcJwtEdqL8JkE8EL8t1boWc19F2g3cFyKlp
         vapn5lVvwB5x2fKi2qqUy3aUcD6YSv+mnISmC90wko8VLHLJNGzqkRUNzSYtzjR2C3
         AmJCuwg7ORXVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, matthew@wil.cx, hare@suse.com,
        JBottomley@odin.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 43/82] scsi: advansys: Fix kernel pointer leak
Date:   Tue,  9 Nov 2021 17:16:01 -0500
Message-Id: <20211109221641.1233217-43-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index ffb3919675734..97be0765cb9bd 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3308,8 +3308,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
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

