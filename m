Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352E04063AB
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhIJAs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234855AbhIJAYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01104611C8;
        Fri, 10 Sep 2021 00:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233421;
        bh=Jk3jxPtXXATLlN6feUIH6VcTx1NIGrREZ3/qSdYUvO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lA3tXlRLyUxpt/mx+sTsSk8euQPvf/7qeaJ8md6fgKJ31VKJnt/S0NxjIRcCGfZE5
         TwZSpfTiRnxfu1iV3j2nf2vewholBytuFNq8ugQdDfo2NOJliXbm+LPSgvKGW46BsD
         zkylnB59P3zSXl7t5GLT06zVjDQg9PSSFJotpEJ6DN0Rte4nat+EssXxy/zrdPOSwO
         bSM6BpqW0KXuoKkFdCz3tZmzhx+1CrHHnnLXKrAnIR0qq6ro6rdm2UoMH+DE1f2NpP
         NSILw/pAhEzlYRxWt/oz2FWJ9JLL79xmSttJ6RtF8Fx00xle8XnHN3CSuMCI5HXXSl
         SV7n496/9g8yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/17] scsi: lpfc: Fix cq_id truncation in rq create
Date:   Thu,  9 Sep 2021 20:23:23 -0400
Message-Id: <20210910002338.176677-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
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
index 2a436dff1589..f2a6f145d66d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1261,7 +1261,7 @@ struct rq_context {
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

