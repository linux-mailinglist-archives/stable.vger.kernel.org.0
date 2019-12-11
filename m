Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864C311B0BF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733050AbfLKPZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732875AbfLKPZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DCA12173E;
        Wed, 11 Dec 2019 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077949;
        bh=hlKtOFs0Tkkrzuq59CYpvYtvrfwPDLYLWxEY2yL9gfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znCMKt2BN40dcH5MSFdfQbUT0NR5H5bcJXbhYNfb7rzVBFNgbIQE2xmsKWP89FYbe
         x6cFoXt2jh1xVRmR9c7LJqVsm/Fb5MsmHJcCRPAqoh8l61gXFO75o8E/eFK6PWGkuJ
         kYfDbkhiutxuIRbq1xz3hym3WaI0OOE1eetDhgdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/243] net: aquantia: fix RSS table and key sizes
Date:   Wed, 11 Dec 2019 16:05:57 +0100
Message-Id: <20191211150352.342346580@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 474fb1150d40780e71f0b569aeac4f375df3af3d ]

Set RSS indirection table and RSS hash key sizes to their real size.

Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index 91eb8910b1c99..90a0e1d0d6221 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -42,8 +42,8 @@
 #define AQ_CFG_IS_LRO_DEF           1U
 
 /* RSS */
-#define AQ_CFG_RSS_INDIRECTION_TABLE_MAX  128U
-#define AQ_CFG_RSS_HASHKEY_SIZE           320U
+#define AQ_CFG_RSS_INDIRECTION_TABLE_MAX  64U
+#define AQ_CFG_RSS_HASHKEY_SIZE           40U
 
 #define AQ_CFG_IS_RSS_DEF           1U
 #define AQ_CFG_NUM_RSS_QUEUES_DEF   AQ_CFG_VECS_DEF
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 4f34808f1e064..8cc34b0bedc3a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -44,7 +44,7 @@ static void aq_nic_rss_init(struct aq_nic_s *self, unsigned int num_rss_queues)
 	struct aq_rss_parameters *rss_params = &cfg->aq_rss;
 	int i = 0;
 
-	static u8 rss_key[40] = {
+	static u8 rss_key[AQ_CFG_RSS_HASHKEY_SIZE] = {
 		0x1e, 0xad, 0x71, 0x87, 0x65, 0xfc, 0x26, 0x7d,
 		0x0d, 0x45, 0x67, 0x74, 0xcd, 0x06, 0x1a, 0x18,
 		0xb6, 0xc1, 0xf0, 0xc7, 0xbb, 0x18, 0xbe, 0xf8,
-- 
2.20.1



