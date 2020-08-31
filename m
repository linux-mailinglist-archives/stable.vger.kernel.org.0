Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA8257DB9
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgHaPjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgHaPaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D7F20E65;
        Mon, 31 Aug 2020 15:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887801;
        bh=B97NLXDNmXiVAlhX37PNK8zdprVaWzpuhoXhsMeIYVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnziI5s3+TGZsvRbY4xCk6Y7N3MEIXo5ya49lPyv2IYoQsHfIgApGZLDHLaXO+kYv
         kPs6tJhWnq1k5IuQMKpp1ny2Vjg+LgBR4QJBNhE2aKVTilVA/3RFFN5oKEw02t+RE7
         KJHHaRZlRvS/fykrdm3gQNKj8JfG0Oz1OKnLYNG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 17/42] habanalabs: proper handling of alloc size in coresight
Date:   Mon, 31 Aug 2020 11:29:09 -0400
Message-Id: <20200831152934.1023912-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 36545279f076afeb77104f5ffeab850da3b6d107 ]

Allocation size can go up to 64bit but truncated to 32bit,
we should make sure it is not truncated and validate no address
overflow.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi_coresight.c | 8 +++++++-
 drivers/misc/habanalabs/goya/goya_coresight.c   | 8 +++++++-
 drivers/misc/habanalabs/habanalabs.h            | 2 +-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi_coresight.c b/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
index bf0e062d7b874..cc3d03549a6e4 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
@@ -523,7 +523,7 @@ static int gaudi_config_etf(struct hl_device *hdev,
 }
 
 static bool gaudi_etr_validate_address(struct hl_device *hdev, u64 addr,
-					u32 size, bool *is_host)
+					u64 size, bool *is_host)
 {
 	struct asic_fixed_properties *prop = &hdev->asic_prop;
 	struct gaudi_device *gaudi = hdev->asic_specific;
@@ -535,6 +535,12 @@ static bool gaudi_etr_validate_address(struct hl_device *hdev, u64 addr,
 		return false;
 	}
 
+	if (addr > (addr + size)) {
+		dev_err(hdev->dev,
+			"ETR buffer size %llu overflow\n", size);
+		return false;
+	}
+
 	/* PMMU and HPMMU addresses are equal, check only one of them */
 	if ((gaudi->hw_cap_initialized & HW_CAP_MMU) &&
 		hl_mem_area_inside_range(addr, size,
diff --git a/drivers/misc/habanalabs/goya/goya_coresight.c b/drivers/misc/habanalabs/goya/goya_coresight.c
index 1258724ea5106..c23a9fcb74b57 100644
--- a/drivers/misc/habanalabs/goya/goya_coresight.c
+++ b/drivers/misc/habanalabs/goya/goya_coresight.c
@@ -358,11 +358,17 @@ static int goya_config_etf(struct hl_device *hdev,
 }
 
 static int goya_etr_validate_address(struct hl_device *hdev, u64 addr,
-		u32 size)
+		u64 size)
 {
 	struct asic_fixed_properties *prop = &hdev->asic_prop;
 	u64 range_start, range_end;
 
+	if (addr > (addr + size)) {
+		dev_err(hdev->dev,
+			"ETR buffer size %llu overflow\n", size);
+		return false;
+	}
+
 	if (hdev->mmu_enable) {
 		range_start = prop->dmmu.start_addr;
 		range_end = prop->dmmu.end_addr;
diff --git a/drivers/misc/habanalabs/habanalabs.h b/drivers/misc/habanalabs/habanalabs.h
index 194d833526964..feedf3194ea6c 100644
--- a/drivers/misc/habanalabs/habanalabs.h
+++ b/drivers/misc/habanalabs/habanalabs.h
@@ -1587,7 +1587,7 @@ struct hl_ioctl_desc {
  *
  * Return: true if the area is inside the valid range, false otherwise.
  */
-static inline bool hl_mem_area_inside_range(u64 address, u32 size,
+static inline bool hl_mem_area_inside_range(u64 address, u64 size,
 				u64 range_start_address, u64 range_end_address)
 {
 	u64 end_address = address + size;
-- 
2.25.1

