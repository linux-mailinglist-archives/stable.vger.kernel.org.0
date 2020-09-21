Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8CE272DF6
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgIUQoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbgIUQon (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC8DF2076B;
        Mon, 21 Sep 2020 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706682;
        bh=QkzFQtbOcFPW+YmrwgpR1H5unI/XIA0Ur6NRyF5Tddo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/nHvgxE+JSF96kDAZ7QergbT3FkdprpdnexYBNtStEXaCTxh6DeC5q9SqblXVNPi
         3N1Wv0GD2aCvvb4sSDUfyixx1J8+5ZMx7iuCB+EHi38sbnyGcsl7MAKrCguMwY02/r
         gKhJqONMCVeHpac1JvA6SC2ZYn9FA7vb6YQaS3Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 051/118] ASoC: core: Do not cleanup uninitialized dais on soc_pcm_open failure
Date:   Mon, 21 Sep 2020 18:27:43 +0200
Message-Id: <20200921162038.697814598@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 20244b2a8a8728c63233d33146e007dcacbcc5c4 ]

Introduce for_each_rtd_dais_rollback macro which behaves exactly like
for_each_codec_dais_rollback and its cpu_dais equivalent but for all
dais instead.

Use newly added macro to fix soc_pcm_open error path and prevent
uninitialized dais from being cleaned-up.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Fixes: 5d9fa03e6c35 ("ASoC: soc-pcm: tidyup soc_pcm_open() order")
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20200907111939.16169-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h | 2 ++
 sound/soc/soc-pcm.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index bc6ecb10c7649..ca765062787b0 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1205,6 +1205,8 @@ struct snd_soc_pcm_runtime {
 	     ((i) < (rtd)->num_cpus + (rtd)->num_codecs) &&		\
 		     ((dai) = (rtd)->dais[i]);				\
 	     (i)++)
+#define for_each_rtd_dais_rollback(rtd, i, dai)		\
+	for (; (--(i) >= 0) && ((dai) = (rtd)->dais[i]);)
 
 void snd_soc_close_delayed_work(struct snd_soc_pcm_runtime *rtd);
 
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 74baf1fce053f..918ed77726cc0 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -811,7 +811,7 @@ dynamic:
 	return 0;
 
 config_err:
-	for_each_rtd_dais(rtd, i, dai)
+	for_each_rtd_dais_rollback(rtd, i, dai)
 		snd_soc_dai_shutdown(dai, substream);
 
 	snd_soc_link_shutdown(substream);
-- 
2.25.1



