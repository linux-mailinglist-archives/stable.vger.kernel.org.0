Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF7A272F5E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgIUQ4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbgIUQod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20902076B;
        Mon, 21 Sep 2020 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706672;
        bh=upFX4R3QFfGh8ArnIGUTH8WK49rVoWf2GnXvBBhJ4RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxSvtc8nco/aKlA1iZNDXtmkfN/uSU0OpTPW7iuPdQtpLRLxaYG83uXhb38FVs2e/
         Yvr3KaDskbPS5tdC3tRfG5nkO2z6JQtGDi2ijxW7s+13dQSK9uUNJ17zVcszJlYiNM
         O0XJXkOY4ixggFZgDzu8v/Yu2ZsVfIL+/qrdrDug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 047/118] ASoC: soc-core: add snd_soc_find_dai_with_mutex()
Date:   Mon, 21 Sep 2020 18:27:39 +0200
Message-Id: <20200921162038.496773463@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 20d9fdee72dfaa1fa7588c7a846283bd740e7157 ]

commit 25612477d20b52 ("ASoC: soc-dai: set dai_link dpcm_ flags with a helper")
added snd_soc_dai_link_set_capabilities().
But it is using snd_soc_find_dai() (A) which is required client_mutex (B).
And client_mutex is soc-core.c local.

	struct snd_soc_dai *snd_soc_find_dai(xxx)
	{
		...
(B)		lockdep_assert_held(&client_mutex);
		...
	}

	void snd_soc_dai_link_set_capabilities(xxx)
	{
		...
		for_each_pcm_streams(direction) {
			...
			for_each_link_cpus(dai_link, i, cpu) {
(A)				dai = snd_soc_find_dai(cpu);
				...
			}
			...
			for_each_link_codecs(dai_link, i, codec) {
(A)				dai = snd_soc_find_dai(codec);
				...
			}
		}
		...
	}

Because of these background, we will get WARNING if .config has CONFIG_LOCKDEP.

	WARNING: CPU: 2 PID: 53 at sound/soc/soc-core.c:814 snd_soc_find_dai+0xf8/0x100
	CPU: 2 PID: 53 Comm: kworker/2:1 Not tainted 5.7.0-rc1+ #328
	Hardware name: Renesas H3ULCB Kingfisher board based on r8a77951 (DT)
	Workqueue: events deferred_probe_work_func
	pstate: 60000005 (nZCv daif -PAN -UAO)
	pc : snd_soc_find_dai+0xf8/0x100
	lr : snd_soc_find_dai+0xf4/0x100
	...
	Call trace:
	 snd_soc_find_dai+0xf8/0x100
	 snd_soc_dai_link_set_capabilities+0xa0/0x16c
	 graph_dai_link_of_dpcm+0x390/0x3c0
	 graph_for_each_link+0x134/0x200
	 graph_probe+0x144/0x230
	 platform_drv_probe+0x5c/0xb0
	 really_probe+0xe4/0x430
	 driver_probe_device+0x60/0xf4

snd_soc_find_dai() will be used from (X) CPU/Codec/Platform driver with
mutex lock, and (Y) Card driver without mutex lock.
This snd_soc_dai_link_set_capabilities() is for Card driver,
this means called without mutex.
This patch adds snd_soc_find_dai_with_mutex() to solve it.

Fixes: 25612477d20b52 ("ASoC: soc-dai: set dai_link dpcm_ flags with a helper")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87blixvuab.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h  |  2 ++
 sound/soc/soc-core.c | 13 +++++++++++++
 sound/soc/soc-dai.c  |  4 ++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 3ce7f0f5aa929..bc6ecb10c7649 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1373,6 +1373,8 @@ void snd_soc_unregister_dai(struct snd_soc_dai *dai);
 
 struct snd_soc_dai *snd_soc_find_dai(
 	const struct snd_soc_dai_link_component *dlc);
+struct snd_soc_dai *snd_soc_find_dai_with_mutex(
+	const struct snd_soc_dai_link_component *dlc);
 
 #include <sound/soc-dai.h>
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index f1d641cd48da9..20ca1d38b4b87 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -834,6 +834,19 @@ struct snd_soc_dai *snd_soc_find_dai(
 }
 EXPORT_SYMBOL_GPL(snd_soc_find_dai);
 
+struct snd_soc_dai *snd_soc_find_dai_with_mutex(
+	const struct snd_soc_dai_link_component *dlc)
+{
+	struct snd_soc_dai *dai;
+
+	mutex_lock(&client_mutex);
+	dai = snd_soc_find_dai(dlc);
+	mutex_unlock(&client_mutex);
+
+	return dai;
+}
+EXPORT_SYMBOL_GPL(snd_soc_find_dai_with_mutex);
+
 static int soc_dai_link_sanity_check(struct snd_soc_card *card,
 				     struct snd_soc_dai_link *link)
 {
diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index cecbbed2de9d5..0e04ad7689cd9 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -410,14 +410,14 @@ void snd_soc_dai_link_set_capabilities(struct snd_soc_dai_link *dai_link)
 		supported_codec = false;
 
 		for_each_link_cpus(dai_link, i, cpu) {
-			dai = snd_soc_find_dai(cpu);
+			dai = snd_soc_find_dai_with_mutex(cpu);
 			if (dai && snd_soc_dai_stream_valid(dai, direction)) {
 				supported_cpu = true;
 				break;
 			}
 		}
 		for_each_link_codecs(dai_link, i, codec) {
-			dai = snd_soc_find_dai(codec);
+			dai = snd_soc_find_dai_with_mutex(codec);
 			if (dai && snd_soc_dai_stream_valid(dai, direction)) {
 				supported_codec = true;
 				break;
-- 
2.25.1



