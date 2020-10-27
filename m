Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032F029C5A2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754065AbgJ0OEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754060AbgJ0OD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:03:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60FBD22264;
        Tue, 27 Oct 2020 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807439;
        bh=6iMBtlQdRbJIag1x6++qJXPiPFHHnfdmxqQxp594tgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfFEvjdOGHUzvF0QDVigA2R4e28cCQiTIAH7uEVJgmcBaM1u/XQV9ILXU7m6CBDEd
         a2lpiW0vWBFfcIJbUgrjJtEkcFmXKxkQpxuzxGy25QMDiDunbcRRj8PJXnKm39zT/L
         wzhVhGOGCV7BYnJUhZQdPUkYhcRGVkn4ZYHL1Oz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/139] scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
Date:   Tue, 27 Oct 2020 14:49:07 +0100
Message-Id: <20201027134904.649655057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 38b2db564d9ab7797192ef15d7aade30633ceeae ]

The be_fill_queue() function can only fail when "eq_vaddress" is NULL and
since it's non-NULL here that means the function call can't fail.  But
imagine if it could, then in that situation we would want to store the
"paddr" so that dma memory can be released.

Link: https://lore.kernel.org/r/20200928091300.GD377727@mwanda
Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 741cc96379cb7..04788e0b90236 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3052,6 +3052,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 		if (!eq_vaddress)
 			goto create_eq_error;
 
+		mem->dma = paddr;
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
 				    sizeof(struct be_eq_entry), eq_vaddress);
@@ -3061,7 +3062,6 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
-		mem->dma = paddr;
 		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
 					    phwi_context->cur_eqd);
 		if (ret) {
@@ -3116,6 +3116,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 		if (!cq_vaddress)
 			goto create_cq_error;
 
+		mem->dma = paddr;
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -3125,7 +3126,6 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
-		mem->dma = paddr;
 		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
 					    false, 0);
 		if (ret) {
-- 
2.25.1



