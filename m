Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9AD360D0D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhDOO4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhDOOzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02A38613E3;
        Thu, 15 Apr 2021 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498399;
        bh=RpUGMDUiqPmS91MBGeZluG4lrVX1QxlKXrNE7ooFDt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxvFtbBDsqRA0nQy/6XmDj1W+D30eM6fptPLJJQEWmY0G88iU2aDAU40pbzWITHHG
         kI+vjsZy+TNuHvUOSdGULYiNEnuj2fNqxxozXMydHYS+uGN93hHGENuvVUv06b0iQt
         ysvDqRNLJvGGZC+ABqIMa/F80Hrd1VZFSDodlvwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/68] amd-xgbe: Update DMA coherency values
Date:   Thu, 15 Apr 2021 16:47:05 +0200
Message-Id: <20210415144415.254388131@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit d75135082698140a26a56defe1bbc1b06f26a41f ]

Based on the IOMMU configuration, the current cache control settings can
result in possible coherency issues. The hardware team has recommended
new settings for the PCI device path to eliminate the issue.

Fixes: 6f595959c095 ("amd-xgbe: Adjust register settings to improve performance")
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 95d4b56448c6..cd0459b0055b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -176,9 +176,9 @@
 #define XGBE_DMA_SYS_AWCR	0x30303030
 
 /* DMA cache settings - PCI device */
-#define XGBE_DMA_PCI_ARCR	0x00000003
-#define XGBE_DMA_PCI_AWCR	0x13131313
-#define XGBE_DMA_PCI_AWARCR	0x00000313
+#define XGBE_DMA_PCI_ARCR	0x000f0f0f
+#define XGBE_DMA_PCI_AWCR	0x0f0f0f0f
+#define XGBE_DMA_PCI_AWARCR	0x00000f0f
 
 /* DMA channel interrupt modes */
 #define XGBE_IRQ_MODE_EDGE	0
-- 
2.30.2



