Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C532E13F644
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437276AbgAPTCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388777AbgAPRFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9739F20730;
        Thu, 16 Jan 2020 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194339;
        bh=CQDizk1U+ffUTXTTxGwiQ2zeRMUYVg5Zx3vc70w1Lho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zL2+wOr13bF4UK83Hcm6buSj1c9T2b6L8Fo8ROt2y6xgwlVDtwghSWOfHJXPaPkpR
         Wnpx3/Y6tgEHJAZsXTkI9L6YGfbevbZMfdwAh9E4y/HhG3dV3AE+GPLaA225uppWjJ
         h+8MeVTUNroync9/qB56Qq0/iEwVaOQSmvcdYva8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 283/671] of: use correct function prototype for of_overlay_fdt_apply()
Date:   Thu, 16 Jan 2020 11:58:41 -0500
Message-Id: <20200116170509.12787-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit ecb0abc1d8528015957fbd034be8bfe760363b3b ]

When CONFIG_OF_OVERLAY is not enabled the fallback stub for
of_overlay_fdt_apply() does not match the prototype for the case when
CONFIG_OF_OVERLAY is enabled. Update the stub to use the correct
function prototype.

Fixes: 39a751a4cb7e ("of: change overlay apply input data from unflattened to FDT")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index dac0201eacef..d4f14b0302b6 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1425,7 +1425,8 @@ int of_overlay_notifier_unregister(struct notifier_block *nb);
 
 #else
 
-static inline int of_overlay_fdt_apply(void *overlay_fdt, int *ovcs_id)
+static inline int of_overlay_fdt_apply(void *overlay_fdt, u32 overlay_fdt_size,
+				       int *ovcs_id)
 {
 	return -ENOTSUPP;
 }
-- 
2.20.1

