Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC83529BBE6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802706AbgJ0Q3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802702AbgJ0Pu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C2F5204EF;
        Tue, 27 Oct 2020 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813856;
        bh=/amRTRH9Qh8DBTjRksWE8cHXZSaHJCgR6d5zKVJpyug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyzVZKmFCx4vswQ3X4vC7yUYqWjvpqJK/9/A+1tx9EFyT1JpP7rB9EbCWwxxQfKLc
         vvN4yM7TFlA636cJKq5rMFQ81tuO4ibsMou+TWZ3BYXYgA4cfRft16BjO32hTE+vdW
         eXgF+QGKchD2zYFBnv7F/MWiQPLnot3tEObRCN0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 694/757] habanalabs: cast to u64 before shift > 31 bits
Date:   Tue, 27 Oct 2020 14:55:44 +0100
Message-Id: <20201027135523.083784023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit f763946aefe67b3ea58696b75a930ba1ed886a83 ]

When shifting a boolean variable by more than 31 bits and putting the
result into a u64 variable, we need to cast the boolean into unsigned 64
bits to prevent possible overflow.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 8 +++++---
 drivers/misc/habanalabs/goya/goya.c   | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 4009b7df4cafe..2e55890ad6a61 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -6099,7 +6099,7 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle <<
+			*mask |= ((u64) !is_eng_idle) <<
 					(GAUDI_ENGINE_ID_DMA_0 + dma_id);
 		if (s)
 			seq_printf(s, fmt, dma_id,
@@ -6122,7 +6122,8 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GAUDI_ENGINE_ID_TPC_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GAUDI_ENGINE_ID_TPC_0 + i);
 		if (s)
 			seq_printf(s, fmt, i,
 				is_eng_idle ? "Y" : "N",
@@ -6150,7 +6151,8 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GAUDI_ENGINE_ID_MME_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GAUDI_ENGINE_ID_MME_0 + i);
 		if (s) {
 			if (!is_slave)
 				seq_printf(s, fmt, i,
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 33cd2ae653d23..c09742f440f96 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5166,7 +5166,8 @@ static bool goya_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GOYA_ENGINE_ID_DMA_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GOYA_ENGINE_ID_DMA_0 + i);
 		if (s)
 			seq_printf(s, dma_fmt, i, is_eng_idle ? "Y" : "N",
 					qm_glbl_sts0, dma_core_sts0);
@@ -5189,7 +5190,8 @@ static bool goya_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GOYA_ENGINE_ID_TPC_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GOYA_ENGINE_ID_TPC_0 + i);
 		if (s)
 			seq_printf(s, fmt, i, is_eng_idle ? "Y" : "N",
 				qm_glbl_sts0, cmdq_glbl_sts0, tpc_cfg_sts);
@@ -5209,7 +5211,7 @@ static bool goya_is_device_idle(struct hl_device *hdev, u32 *mask,
 	is_idle &= is_eng_idle;
 
 	if (mask)
-		*mask |= !is_eng_idle << GOYA_ENGINE_ID_MME_0;
+		*mask |= ((u64) !is_eng_idle) << GOYA_ENGINE_ID_MME_0;
 	if (s) {
 		seq_printf(s, fmt, 0, is_eng_idle ? "Y" : "N", qm_glbl_sts0,
 				cmdq_glbl_sts0, mme_arch_sts);
-- 
2.25.1



