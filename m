Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625204061EA
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhIJAoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhIJATz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B597611BD;
        Fri, 10 Sep 2021 00:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233125;
        bh=llGQfHUJf9wbBAkwnSjGXKp3Gz0mt66NEPEa/XyLQ+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obRpcoPK6/exJJqYAh0xWiMlsXF9SLfaTRo7y4w15h8CLbgbfVo8KUttj2+76U8rV
         lDDLumzsIzvmgnMjB/kkhgCoqU9R3EkQnZ1Q/+df69+MDq/cWcV5dDYrLSNxJAlzut
         4tyOjRZpNq6El7SajmInrTo77dOUsI+vDgUakcK2vx9V48CtBpWNIsTnHXfkIFQSUI
         nknwSMu8tRu2yBc7gm/Q9EIbXBX/RqEmD2Ofk9i78W3SfZS8qMgjRLfpzk5Ugvk/WY
         staOyYS9soHWtvr2zEo9UL/HtTYan3d7mHweP9Kzzrk2Kl/m9kzwYy987jKg3myC8r
         8Sd14TSLACVKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 17/88] scsi: lpfc: Fix cq_id truncation in rq create
Date:   Thu,  9 Sep 2021 20:17:09 -0400
Message-Id: <20210910001820.174272-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index f77e71e6dbbd..3be78d22d9c3 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1552,7 +1552,7 @@ struct rq_context {
 #define lpfc_rq_context_hdr_size_WORD	word1
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
-#define lpfc_rq_context_cq_id_MASK	0x000003FF
+#define lpfc_rq_context_cq_id_MASK	0x0000FFFF
 #define lpfc_rq_context_cq_id_WORD	word2
 #define lpfc_rq_context_buf_size_SHIFT	0
 #define lpfc_rq_context_buf_size_MASK	0x0000FFFF
-- 
2.30.2

