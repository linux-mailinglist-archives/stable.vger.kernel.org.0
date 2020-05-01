Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E041C149B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbgEANlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgEANlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC7FF2173E;
        Fri,  1 May 2020 13:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340472;
        bh=tNbHRXvQVRQnm7qv6Y3bHuOuLUu/Gt2nW45E8Gy/QLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQIok6k8Es+yACvJ+Hy+sv3vI0cNtLwW5rb8hh/x4ayk9J+HlNKxgHT6jsMobQffL
         yLhXcBgsPMwuxbbaKgm1ge4LZCNbCNONg9TmGjUW1kDNGGPTZ8oDDj13bgQMw5XZ6B
         Abc+C0dK1sgYu9lxTgVcIi2aYQnDVQ0/hSD0R57k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 82/83] ASoC: soc-core: disable route checks for legacy devices
Date:   Fri,  1 May 2020 15:24:01 +0200
Message-Id: <20200501131543.210193855@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
@@ -1059,6 +1059,7 @@ struct snd_soc_card {
 	const struct snd_soc_dapm_route *of_dapm_routes;
 	int num_of_dapm_routes;
 	bool fully_routed;
+	bool disable_route_checks;
 
 	/* lists of probed devices belonging to this card */
 	struct list_head component_dev_list;
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1076,8 +1076,18 @@ static int soc_probe_component(struct sn
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
@@ -2067,8 +2077,18 @@ static int snd_soc_instantiate_card(stru
 
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


