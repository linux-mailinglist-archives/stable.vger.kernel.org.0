Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FDE24733B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbgHQSxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387688AbgHQPwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:52:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9152063A;
        Mon, 17 Aug 2020 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679522;
        bh=5g143PedhAMhKBn4Ao3RmJSWsNaby5hpi/DdzB/TTXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IS7/qZEY3iZbyyXXC0wWRc6WodvufQhva59haG26FHiwN5ZxxExwkre/x1IyEeXf3
         isrCPLDMidfTwz/d5/Hu64Y4toE/XWQg2H8ksevJZxIChTDf9AGLeKt/T9Rf2gU3rj
         df9YuOvzdDZs+al4S+qjZYYBl3wZ6+2j/2jhX7GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 241/393] ASoC: hdac_hda: fix deadlock after PCM open error
Date:   Mon, 17 Aug 2020 17:14:51 +0200
Message-Id: <20200817143831.308733070@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 06f07e2365378d51eddd0b5bf23506e1237662b0 ]

Commit 5bd70440cb0a ("ASoC: soc-dai: revert all changes to DAI
startup/shutdown sequence"), introduced a slight change of semantics
to DAI startup/shutdown. If startup() returns an error, shutdown()
is now called for the DAI.

This causes a deadlock in hdac_hda which issues a call to
snd_hda_codec_pcm_put() in case open fails. Upon error, soc_pcm_open()
will call shutdown(), and pcm_put() ends up getting called twice. Result
is a deadlock on pcm->open_mutex, as snd_device_free() gets called from
within snd_pcm_open(). Typical task backtrace looks like this:

[  334.244627]  snd_pcm_dev_disconnect+0x49/0x340 [snd_pcm]
[  334.244634]  __snd_device_disconnect.part.0+0x2c/0x50 [snd]
[  334.244640]  __snd_device_free+0x7f/0xc0 [snd]
[  334.244650]  snd_hda_codec_pcm_put+0x87/0x120 [snd_hda_codec]
[  334.244660]  soc_pcm_open+0x6a0/0xbe0 [snd_soc_core]
[  334.244676]  ? dpcm_add_paths.isra.0+0x491/0x590 [snd_soc_core]
[  334.244679]  ? kfree+0x9a/0x230
[  334.244686]  dpcm_be_dai_startup+0x255/0x300 [snd_soc_core]
[  334.244695]  dpcm_fe_dai_open+0x20e/0xf30 [snd_soc_core]
[  334.244701]  ? snd_pcm_hw_rule_muldivk+0x110/0x110 [snd_pcm]
[  334.244709]  ? dpcm_be_dai_startup+0x300/0x300 [snd_soc_core]
[  334.244714]  ? snd_pcm_attach_substream+0x3c4/0x540 [snd_pcm]
[  334.244719]  snd_pcm_open_substream+0x69a/0xb60 [snd_pcm]
[  334.244729]  ? snd_pcm_release_substream+0x30/0x30 [snd_pcm]
[  334.244732]  ? __mutex_lock_slowpath+0x10/0x10
[  334.244736]  snd_pcm_open+0x1b3/0x3c0 [snd_pcm]

Fixes: 5bd70440cb0a ("ASoC: soc-dai: revert all changes to DAI startup/shutdown sequence")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
BugLink: https://github.com/thesofproject/linux/issues/2159
Link: https://lore.kernel.org/r/20200717101950.3885187-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 473efe9ef998a..b0370bb10c142 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -289,7 +289,6 @@ static int hdac_hda_dai_open(struct snd_pcm_substream *substream,
 	struct hdac_hda_priv *hda_pvt;
 	struct hda_pcm_stream *hda_stream;
 	struct hda_pcm *pcm;
-	int ret;
 
 	hda_pvt = snd_soc_component_get_drvdata(component);
 	pcm = snd_soc_find_pcm_from_dai(hda_pvt, dai);
@@ -300,11 +299,7 @@ static int hdac_hda_dai_open(struct snd_pcm_substream *substream,
 
 	hda_stream = &pcm->stream[substream->stream];
 
-	ret = hda_stream->ops.open(hda_stream, &hda_pvt->codec, substream);
-	if (ret < 0)
-		snd_hda_codec_pcm_put(pcm);
-
-	return ret;
+	return hda_stream->ops.open(hda_stream, &hda_pvt->codec, substream);
 }
 
 static void hdac_hda_dai_close(struct snd_pcm_substream *substream,
-- 
2.25.1



