Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCDE1FE73F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgFRBMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbgFRBMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A3321924;
        Thu, 18 Jun 2020 01:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442769;
        bh=/wUskEBPkDlGuTw0FJYcgRRsQyOeMwrGcwZ4cte4Wio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+hCTKDGJxy9oH0L/DBpdkf3BsnF9vUfgayR6mawzI+17hZ38ECHlvcyzZwcyEGAc
         dphGmdWmCfcdINv5UQznF2umiOJBaullXBymIooZXzvAy5przLiRbyjCArG/ofRWZt
         +6A4Wgy7JE3mcwM6ulwTl/FHuDVlb8cSrNWmd1qw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Shuming Fan <shumingf@realtek.com>,
        Jack Yu <jack.yu@realtek.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 217/388] ASoC: codecs: rt*-sdw: fix memory leak in set_sdw_stream()
Date:   Wed, 17 Jun 2020 21:05:14 -0400
Message-Id: <20200618010805.600873-217-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 07b542fe831cbefce163ad1b3aa7292c8a6332b8 ]

Now that the sdw_stream is allocated in machine driver,
set_sdw_stream() is also called with a NULL argument during the
dailink shutdown.

In this case, the drivers should not allocate any memory, and just
return.

Detected with KASAN/kmemleak.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Cc: Oder Chiou <oder_chiou@realtek.com>
Cc: Shuming Fan <shumingf@realtek.com>
Cc: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/20200515211531.11416-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.c | 3 +++
 sound/soc/codecs/rt5682.c     | 3 +++
 sound/soc/codecs/rt700.c      | 3 +++
 sound/soc/codecs/rt711.c      | 3 +++
 sound/soc/codecs/rt715.c      | 3 +++
 5 files changed, 15 insertions(+)

diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index a5a7e46de246..a7f45191364d 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -482,6 +482,9 @@ static int rt1308_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
 {
 	struct sdw_stream_data *stream;
 
+	if (!sdw_stream)
+		return 0;
+
 	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
 	if (!stream)
 		return -ENOMEM;
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index d36f560ad7a8..c4892af14850 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -2958,6 +2958,9 @@ static int rt5682_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
 {
 	struct sdw_stream_data *stream;
 
+	if (!sdw_stream)
+		return 0;
+
 	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
 	if (!stream)
 		return -ENOMEM;
diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index ff68f0e4f629..687ac2153666 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -860,6 +860,9 @@ static int rt700_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
 {
 	struct sdw_stream_data *stream;
 
+	if (!sdw_stream)
+		return 0;
+
 	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
 	if (!stream)
 		return -ENOMEM;
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 2daed7692a3b..65b59dbfb43c 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -906,6 +906,9 @@ static int rt711_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
 {
 	struct sdw_stream_data *stream;
 
+	if (!sdw_stream)
+		return 0;
+
 	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
 	if (!stream)
 		return -ENOMEM;
diff --git a/sound/soc/codecs/rt715.c b/sound/soc/codecs/rt715.c
index 2cbc57b16b13..099c8bd20006 100644
--- a/sound/soc/codecs/rt715.c
+++ b/sound/soc/codecs/rt715.c
@@ -530,6 +530,9 @@ static int rt715_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
 
 	struct sdw_stream_data *stream;
 
+	if (!sdw_stream)
+		return 0;
+
 	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
 	if (!stream)
 		return -ENOMEM;
-- 
2.25.1

