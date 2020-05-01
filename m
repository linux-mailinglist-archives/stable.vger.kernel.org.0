Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD31C1515
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgEANpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731890AbgEANpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35CF72051A;
        Fri,  1 May 2020 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340730;
        bh=nXbzyxmadLvJuaCsaOTtLsZsY1vol51ZFefbb2aIuaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deqpB4PSfmm8Ix0zkNnvHXRaUQHqBg8D4JM217Aj2nN3MUoJAkWEUi2ivZWNjBco+
         a+QXLWcpktwgHjXvoQ3+qs16HxQPCbCPIz8q7b/iz5cB1fYuTT0MauGhC7cFOyMc+U
         /T8Fiq5/O/DgSmvR95VQy+zmQjBTSHcZr/qe4UlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 105/106] ASoC: soc-core: disable route checks for legacy devices
Date:   Fri,  1 May 2020 15:24:18 +0200
Message-Id: <20200501131556.001397168@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit a22ae72b86a4f754e8d25fbf9ea5a8f77365e531 upstream.

v5.4 changes in soc-core tightened the checks on soc_dapm_add_routes,
which results in the ASoC card probe failing.

Introduce a flag to be set in machine drivers to prevent the probe
from stopping in case of incomplete topologies or missing routes. This
flag is for backwards compatibility only and shall not be used for
newer machine drivers.

Example with an HDaudio card with a bad topology:

[ 236.177898] skl_hda_dsp_generic skl_hda_dsp_generic: ASoC: Failed to
add route iDisp1_out -> direct -> iDisp1 Tx

[ 236.177902] skl_hda_dsp_generic skl_hda_dsp_generic:
snd_soc_bind_card: snd_soc_dapm_add_routes failed: -19

with the disable_route_checks set:

[ 64.031657] skl_hda_dsp_generic skl_hda_dsp_generic: ASoC: Failed to
add route iDisp1_out -> direct -> iDisp1 Tx

[ 64.031661] skl_hda_dsp_generic skl_hda_dsp_generic:
snd_soc_bind_card: disable_route_checks set, ignoring errors on
add_routes

Fixes: daa480bde6b3a9 ("ASoC: soc-core: tidyup for snd_soc_dapm_add_routes()")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20200309192744.18380-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/soc.h  |    1 +
 sound/soc/soc-core.c |   28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1058,6 +1058,7 @@ struct snd_soc_card {
 	const struct snd_soc_dapm_route *of_dapm_routes;
 	int num_of_dapm_routes;
 	bool fully_routed;
+	bool disable_route_checks;
 
 	/* lists of probed devices belonging to this card */
 	struct list_head component_dev_list;
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1256,8 +1256,18 @@ static int soc_probe_component(struct sn
 	ret = snd_soc_dapm_add_routes(dapm,
 				      component->driver->dapm_routes,
 				      component->driver->num_dapm_routes);
-	if (ret < 0)
-		goto err_probe;
+	if (ret < 0) {
+		if (card->disable_route_checks) {
+			dev_info(card->dev,
+				 "%s: disable_route_checks set, ignoring errors on add_routes\n",
+				 __func__);
+		} else {
+			dev_err(card->dev,
+				"%s: snd_soc_dapm_add_routes failed: %d\n",
+				__func__, ret);
+			goto err_probe;
+		}
+	}
 
 	/* see for_each_card_components */
 	list_add(&component->card_list, &card->component_dev_list);
@@ -1938,8 +1948,18 @@ static int snd_soc_bind_card(struct snd_
 
 	ret = snd_soc_dapm_add_routes(&card->dapm, card->dapm_routes,
 				      card->num_dapm_routes);
-	if (ret < 0)
-		goto probe_end;
+	if (ret < 0) {
+		if (card->disable_route_checks) {
+			dev_info(card->dev,
+				 "%s: disable_route_checks set, ignoring errors on add_routes\n",
+				 __func__);
+		} else {
+			dev_err(card->dev,
+				 "%s: snd_soc_dapm_add_routes failed: %d\n",
+				 __func__, ret);
+			goto probe_end;
+		}
+	}
 
 	ret = snd_soc_dapm_add_routes(&card->dapm, card->of_dapm_routes,
 				      card->num_of_dapm_routes);


