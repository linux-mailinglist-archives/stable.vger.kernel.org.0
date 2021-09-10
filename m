Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56134063C0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhIJAsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234302AbhIJAZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE69E60FC0;
        Fri, 10 Sep 2021 00:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233445;
        bh=nH4sHP+304l9G2n3ttkn/B9XbPM308IfJGptkYB5ogA=;
        h=From:To:Cc:Subject:Date:From;
        b=tiJEXwk21DF698ZIHY1HGJUv5MjIY6OHtzyG4ouHL50GRrfFCu40jGbmYRCwnF/oF
         oY0KjCKIeVsH4Y1V8pnwV+kd3GgZgwOYGhu/D7TY781VyX3pau/AnB/eXx9tSEb7vT
         ntlOBdDbJMMSPrZv4OxdMyiOIbNczukpCUEPNcBwAqmdJ+2vh4liBRu0CV+CwZi8sh
         smcgJVKIPx6e62iX/lqOEPygoVi8JkAcFu0f2W4r5USYODEcqc+aV7cvB7T64hDAR/
         NOOjEZO6N0d0rv1ZB/pWSsd75qwNoTfWuvvgA2cRqG+RYdB5t0VS1RVB5XNlhRDUir
         2piNVq64NTJ/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/14] scsi: lpfc: Fix cq_id truncation in rq create
Date:   Thu,  9 Sep 2021 20:23:50 -0400
Message-Id: <20210910002403.176887-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit df3d78c3eb4eba13b3ef9740a8c664508ee644ae ]

On the newer hardware, CQ_ID values can be larger than seen on previous
generations. This exposed an issue in the driver where its definition of
cq_id in the RQ Create mailbox cmd was too small, thus the cq_id was
truncated, causing the command to fail.

Revise the RQ_CREATE CQ_ID field to its proper size (16 bits).

Link: https://lore.kernel.org/r/20210722221721.74388-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 507869bc0673..e7ad2ef86514 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1258,7 +1258,7 @@ struct rq_context {
 	uint32_t reserved1;
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
-#define lpfc_rq_context_cq_id_MASK	0x000003FF
+#define lpfc_rq_context_cq_id_MASK	0x0000FFFF
 #define lpfc_rq_context_cq_id_WORD	word2
 #define lpfc_rq_context_buf_size_SHIFT	0
 #define lpfc_rq_context_buf_size_MASK	0x0000FFFF
-- 
2.30.2

