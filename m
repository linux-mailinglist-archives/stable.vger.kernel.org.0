Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9080429BD48
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794976AbgJ0POl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794969AbgJ0POk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:14:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D5820657;
        Tue, 27 Oct 2020 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811679;
        bh=vTaxP/Ekyc5Pa8UyF7ePf+/WcBxBH/HKiBPLA17whKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwzDnR+iJJgNtKuff3sIY2JVbQGPVJjj6AJh1uNS89pNYXKlWUhwMCxAtdEe7Riq3
         sZc/m6TdO0gp1nCLKXVTWtAztVYPDoeryx5KSlv9s3CfEiXFzR6IYMXiJIX7t6rDQs
         kBn77FzKdmIR9cDdf/DHHZ0mcmfD5PUPFtNrdPmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 577/633] habanalabs: cast to u64 before shift > 31 bits
Date:   Tue, 27 Oct 2020 14:55:20 +0100
Message-Id: <20201027135549.878325296@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index ca183733847b6..bcc45bf7af2c8 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -6285,7 +6285,7 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle <<
+			*mask |= ((u64) !is_eng_idle) <<
 					(GAUDI_ENGINE_ID_DMA_0 + dma_id);
 		if (s)
 			seq_printf(s, fmt, dma_id,
@@ -6308,7 +6308,8 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GAUDI_ENGINE_ID_TPC_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GAUDI_ENGINE_ID_TPC_0 + i);
 		if (s)
 			seq_printf(s, fmt, i,
 				is_eng_idle ? "Y" : "N",
@@ -6336,7 +6337,8 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GAUDI_ENGINE_ID_MME_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GAUDI_ENGINE_ID_MME_0 + i);
 		if (s) {
 			if (!is_slave)
 				seq_printf(s, fmt, i,
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index c179085ced7b8..a8041a39fae31 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5098,7 +5098,8 @@ static bool goya_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GOYA_ENGINE_ID_DMA_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GOYA_ENGINE_ID_DMA_0 + i);
 		if (s)
 			seq_printf(s, dma_fmt, i, is_eng_idle ? "Y" : "N",
 					qm_glbl_sts0, dma_core_sts0);
@@ -5121,7 +5122,8 @@ static bool goya_is_device_idle(struct hl_device *hdev, u32 *mask,
 		is_idle &= is_eng_idle;
 
 		if (mask)
-			*mask |= !is_eng_idle << (GOYA_ENGINE_ID_TPC_0 + i);
+			*mask |= ((u64) !is_eng_idle) <<
+						(GOYA_ENGINE_ID_TPC_0 + i);
 		if (s)
 			seq_printf(s, fmt, i, is_eng_idle ? "Y" : "N",
 				qm_glbl_sts0, cmdq_glbl_sts0, tpc_cfg_sts);
@@ -5141,7 +5143,7 @@ static bool goya_is_device_idle(struct hl_device *hdev, u32 *mask,
 	is_idle &= is_eng_idle;
 
 	if (mask)
-		*mask |= !is_eng_idle << GOYA_ENGINE_ID_MME_0;
+		*mask |= ((u64) !is_eng_idle) << GOYA_ENGINE_ID_MME_0;
 	if (s) {
 		seq_printf(s, fmt, 0, is_eng_idle ? "Y" : "N", qm_glbl_sts0,
 				cmdq_glbl_sts0, mme_arch_sts);
-- 
2.25.1



