Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADDCC1879
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbfI2Rbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfI2Rbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39084218AC;
        Sun, 29 Sep 2019 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778291;
        bh=RElNQWC1sL5bV1os5V5P26hwdNH57/88suKAzPs2f5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/GJKK+Vi+s1t0WdGsuwa2jWJyruhHmPYVczYU3TgV0PLA01cafTVwQRBPShlyfqx
         5z1Sop0W+u8dFUl4qCkh/rG9pp7/VlISVbo7x/qnCaedUYV/Oni7jqRkBrgyame0jU
         MR6ANyqoYnAH0SfIuWQpa2GN1FBlDJEBWGzj/8J0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 16/49] soundwire: intel: fix channel number reported by hardware
Date:   Sun, 29 Sep 2019 13:30:16 -0400
Message-Id: <20190929173053.8400-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 18046335643de6d21327f5ae034c8fb8463f6715 ]

On all released Intel controllers (CNL/CML/ICL), PDI2 reports an
invalid count, force the correct hardware-supported value

This may have to be revisited with platform-specific values if the
hardware changes, but for now this is good enough.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190806005522.22642-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 317873bc0555d..ec25a71d08873 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -289,6 +289,16 @@ intel_pdi_get_ch_cap(struct sdw_intel *sdw, unsigned int pdi_num, bool pcm)
 
 	if (pcm) {
 		count = intel_readw(shim, SDW_SHIM_PCMSYCHC(link_id, pdi_num));
+
+		/*
+		 * WORKAROUND: on all existing Intel controllers, pdi
+		 * number 2 reports channel count as 1 even though it
+		 * supports 8 channels. Performing hardcoding for pdi
+		 * number 2.
+		 */
+		if (pdi_num == 2)
+			count = 7;
+
 	} else {
 		count = intel_readw(shim, SDW_SHIM_PDMSCAP(link_id));
 		count = ((count & SDW_SHIM_PDMSCAP_CPSS) >>
-- 
2.20.1

