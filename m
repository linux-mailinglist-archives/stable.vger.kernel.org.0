Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC314EF1
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfEFOho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbfEFOho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB18204EC;
        Mon,  6 May 2019 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153463;
        bh=VlWkBUEImB78/og5ALQ2v1xG5jr0UAHU6iU6re1Vq5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPCWpawv6Xf7EZAger1HMUauaIj2knqUtI/fLd/2VpGmIZP1iD/qkOrRDP6FwiQG1
         f9/uPLZFQTinQfjk5oPpLOOwsKZdXmxT9HOd5cmm2o7/aVKBHoUj1ilv+kEqz95CO9
         k8zXNrldZzsaYl6RFQz0WDPXQsSTECguUDXWhmBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.0 098/122] ASoC: dpcm: skip missing substream while applying symmetry
Date:   Mon,  6 May 2019 16:32:36 +0200
Message-Id: <20190506143103.555118908@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 6246f283d5e02ac757bd8d9bacde8fdc54c4582d upstream.

If for any reason, the backend does not have the requested substream
(like capture on a playback only backend), the BE will be skipped in
dpcm_be_dai_startup().

However, dpcm_apply_symmetry() does not skip those BE and will
dereference the be_substream (NULL) pointer anyway.

Like in dpcm_be_dai_startup(), just skip those BE.

Fixes: 906c7d690c3b ("ASoC: dpcm: Apply symmetry for DPCM")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1895,10 +1895,15 @@ static int dpcm_apply_symmetry(struct sn
 		struct snd_soc_pcm_runtime *be = dpcm->be;
 		struct snd_pcm_substream *be_substream =
 			snd_soc_dpcm_get_substream(be, stream);
-		struct snd_soc_pcm_runtime *rtd = be_substream->private_data;
+		struct snd_soc_pcm_runtime *rtd;
 		struct snd_soc_dai *codec_dai;
 		int i;
 
+		/* A backend may not have the requested substream */
+		if (!be_substream)
+			continue;
+
+		rtd = be_substream->private_data;
 		if (rtd->dai_link->be_hw_params_fixup)
 			continue;
 


