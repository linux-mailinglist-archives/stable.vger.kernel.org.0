Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604EC35BE42
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbhDLI5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239011AbhDLIzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C01CE61247;
        Mon, 12 Apr 2021 08:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217686;
        bh=jQBx3/5I1CRRTRDB7nEkFUVk7+XYHv83qCpq3pAo3QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0IPL2Ob6ESTM2/F6b/rZ4jZSRAMV2LikA03aNxij7nVEj5tr512RgRbpEdjD76X+
         B3loWzzfCLu4WFHR0e6OOtb/8EKLbYXjwWSJ1g8R+hEJ/UirMivA57LpM0x7ucK+oK
         Fg0zVVJ6C7ZIWM0DS5owox8Zw0Jny4smu49pJTDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/188] amd-xgbe: Update DMA coherency values
Date:   Mon, 12 Apr 2021 10:40:23 +0200
Message-Id: <20210412084017.265139515@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index ba8321ec1ee7..3305979a9f7c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -180,9 +180,9 @@
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



