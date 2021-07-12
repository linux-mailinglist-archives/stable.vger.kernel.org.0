Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34D83C5569
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355683AbhGLIKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353628AbhGLICi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCDA46141A;
        Mon, 12 Jul 2021 07:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076559;
        bh=ltdWVT6jllalnp0WWQxqbavgaYqE5bB1QLzV0T48/Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2/vrDR0z+m+DuCJvxuRhzY8wV+gNN5bL1DTx+Q1z4w6jMjb3G8W4RY4RqB+7G795
         yju+qsp5Y7tGWul+Thgm/1j53LOC50tiahwIImPog96mSmJx+zy76ZXGUXq0JpEdqJ
         NO9LNSxo4iI8AK6X/DPiZCbM9d5HxWz3+/d2btqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bard Liao <bard.liao@intel.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 694/800] ASoC: rt5682: Fix a problem with error handling in the io init function of the soundwire
Date:   Mon, 12 Jul 2021 08:11:57 +0200
Message-Id: <20210712061040.681497300@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 9266d95405ae0c078f188ec8bca3a004631be429 ]

The device checking error should be a jump to pm_runtime_put_autosuspend()
as done before returning value.

Fixes: 867f8d18df4f ('ASoC: rt5682: fix getting the wrong device id when the suspend_stress_test')
Reviewed-by: Bard Liao <bard.liao@intel.com>
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-13-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 8e4bb9dd194e..529a85fd0a00 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -408,9 +408,11 @@ static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 		usleep_range(30000, 30005);
 		loop--;
 	}
+
 	if (val != DEVICE_ID) {
 		dev_err(dev, "Device with ID register %x is not rt5682\n", val);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_nodev;
 	}
 
 	if (rt5682->first_hw_init) {
@@ -486,10 +488,11 @@ reinit:
 	rt5682->hw_init = true;
 	rt5682->first_hw_init = true;
 
+err_nodev:
 	pm_runtime_mark_last_busy(&slave->dev);
 	pm_runtime_put_autosuspend(&slave->dev);
 
-	dev_dbg(&slave->dev, "%s hw_init complete\n", __func__);
+	dev_dbg(&slave->dev, "%s hw_init complete: %d\n", __func__, ret);
 
 	return ret;
 }
-- 
2.30.2



