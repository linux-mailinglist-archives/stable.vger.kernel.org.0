Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3589E420EEC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhJDN30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236358AbhJDN17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B978D61B7F;
        Mon,  4 Oct 2021 13:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353141;
        bh=UfSqkBk9FStrSwiZKqdl42llm3bzbVxvtR6OatMzF7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHMV3et0REZm69V/vykF0bdDcXghpI9KTm6RSSt/CIFMDhao7fZX5qMIlo1joICjK
         bTgspFUsIwlAK++z/mxOF2ccdfzIEkcffFrUh7DL2gd6TnIMOaDwSI8ArmDK+Xpoz4
         s5HMOedg2DyCQ+M3CLZji1gAfamsE9ZtNSSWzawQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 012/172] ASoC: SOF: imx: imx8: Bar index is only valid for IRAM and SRAM types
Date:   Mon,  4 Oct 2021 14:51:02 +0200
Message-Id: <20211004125045.363549779@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 10d93a98190aec2c3ff98d9472ab1bf0543aa02c ]

i.MX8 only uses SOF_FW_BLK_TYPE_IRAM (1) and SOF_FW_BLK_TYPE_SRAM (3)
bars, everything else is left as 0 in sdev->bar[] array.

If a broken or purposefully crafted firmware image is loaded with other
types of FW_BLK_TYPE then a kernel crash can be triggered.

Make sure that only IRAM/SRAM type is converted to bar index.

Fixes: 202acc565a1f0 ("ASoC: SOF: imx: Add i.MX8 HW support")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@gmail.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Link: https://lore.kernel.org/r/20210915122116.18317-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/imx8.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/imx/imx8.c b/sound/soc/sof/imx/imx8.c
index 12fedf0984bd..7e9723a10d02 100644
--- a/sound/soc/sof/imx/imx8.c
+++ b/sound/soc/sof/imx/imx8.c
@@ -365,7 +365,14 @@ static int imx8_remove(struct snd_sof_dev *sdev)
 /* on i.MX8 there is 1 to 1 match between type and BAR idx */
 static int imx8_get_bar_index(struct snd_sof_dev *sdev, u32 type)
 {
-	return type;
+	/* Only IRAM and SRAM bars are valid */
+	switch (type) {
+	case SOF_FW_BLK_TYPE_IRAM:
+	case SOF_FW_BLK_TYPE_SRAM:
+		return type;
+	default:
+		return -EINVAL;
+	}
 }
 
 static void imx8_ipc_msg_data(struct snd_sof_dev *sdev,
-- 
2.33.0



