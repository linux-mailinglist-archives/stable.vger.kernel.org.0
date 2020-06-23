Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944F5205D2A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388755AbgFWUJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388753AbgFWUJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E1A4206C3;
        Tue, 23 Jun 2020 20:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942985;
        bh=OyisKOes58HM8UbcROpprrTjWCiGFqxSY88huNCNfAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FghXY2EA1TEtLyiM+9sX4AatmXCTdadSshqzAwd8b7stMD5Z11lv7DPSGPBHQPU4K
         hffZVucvEN4+E1zN6FFNtszYet/uf5YNERlDwQee0FlSgGMdsJh7DXE3GNgmqRwVmK
         +jznPA/s5SZnVKkq7F9MVETA8lp+vZffJdP/BHKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Shuming Fan <shumingf@realtek.com>,
        Jack Yu <jack.yu@realtek.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 214/477] ASoC: codecs: rt*-sdw: fix memory leak in set_sdw_stream()
Date:   Tue, 23 Jun 2020 21:53:31 +0200
Message-Id: <20200623195417.700777729@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a5a7e46de246a..a7f45191364d7 100644
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
index d36f560ad7a85..c4892af14850d 100644
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
index ff68f0e4f629d..687ac2153666b 100644
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
index 2daed7692a3b7..65b59dbfb43c8 100644
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
index 2cbc57b16b136..099c8bd200062 100644
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



