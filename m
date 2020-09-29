Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2DC27CD05
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgI2MlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgI2LNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:13:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B506421D46;
        Tue, 29 Sep 2020 11:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378032;
        bh=jUtQX6nZHKTwIyA2f40aoFnLm/DrVK0Fk+Q6WWSm8So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFpV6FHBIKygdR+RyFfcOepejL0mY4/YhUNLoBaKXkvIe8lnxAfM5f3F4wWHTNjnV
         XydGkQW288eFw7MpErkpPhEVQ5XNB6r/E2XVNfbmFVYk7nJKtFlY1lHEV2Qskf2OmV
         Aa96XOOQVhJBuf6q3iZ/ddRREPQRh50Qh6fQtR8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bradley Bolen <bradleybolen@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/166] mmc: core: Fix size overflow for mmc partitions
Date:   Tue, 29 Sep 2020 12:59:10 +0200
Message-Id: <20200929105937.106531814@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bradley Bolen <bradleybolen@gmail.com>

[ Upstream commit f3d7c2292d104519195fdb11192daec13229c219 ]

With large eMMC cards, it is possible to create general purpose
partitions that are bigger than 4GB.  The size member of the mmc_part
struct is only an unsigned int which overflows for gp partitions larger
than 4GB.  Change this to a u64 to handle the overflow.

Signed-off-by: Bradley Bolen <bradleybolen@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/mmc.c   | 9 ++++-----
 include/linux/mmc/card.h | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 814a04e8fdd77..2be2313f5950a 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -300,7 +300,7 @@ static void mmc_manage_enhanced_area(struct mmc_card *card, u8 *ext_csd)
 	}
 }
 
-static void mmc_part_add(struct mmc_card *card, unsigned int size,
+static void mmc_part_add(struct mmc_card *card, u64 size,
 			 unsigned int part_cfg, char *name, int idx, bool ro,
 			 int area_type)
 {
@@ -316,7 +316,7 @@ static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
 {
 	int idx;
 	u8 hc_erase_grp_sz, hc_wp_grp_sz;
-	unsigned int part_size;
+	u64 part_size;
 
 	/*
 	 * General purpose partition feature support --
@@ -346,8 +346,7 @@ static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
 				(ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1]
 				<< 8) +
 				ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3];
-			part_size *= (size_t)(hc_erase_grp_sz *
-				hc_wp_grp_sz);
+			part_size *= (hc_erase_grp_sz * hc_wp_grp_sz);
 			mmc_part_add(card, part_size << 19,
 				EXT_CSD_PART_CONFIG_ACC_GP0 + idx,
 				"gp%d", idx, false,
@@ -365,7 +364,7 @@ static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
 static int mmc_decode_ext_csd(struct mmc_card *card, u8 *ext_csd)
 {
 	int err = 0, idx;
-	unsigned int part_size;
+	u64 part_size;
 	struct device_node *np;
 	bool broken_hpi = false;
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 279b39008a33b..de81ed857ea37 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -226,7 +226,7 @@ struct mmc_queue_req;
  * MMC Physical partitions
  */
 struct mmc_part {
-	unsigned int	size;	/* partition size (in bytes) */
+	u64		size;	/* partition size (in bytes) */
 	unsigned int	part_cfg;	/* partition type */
 	char	name[MAX_MMC_PART_NAME_LEN];
 	bool	force_ro;	/* to make boot parts RO by default */
-- 
2.25.1



