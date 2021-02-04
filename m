Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E46530CBC5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhBBTfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233302AbhBBN4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6587B64FDE;
        Tue,  2 Feb 2021 13:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273522;
        bh=mdqmBXuueKeG0pdRe54jBkL0RRK1cjuIaM54TGX+Z5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7rJycKHtqMGAzT9Kkcr/kgSEnCPSDqc3MmzARdvShNu8klRoCZegxjyARJxjApoq
         123/VgvwgLYG+OxR8AAhX/6rOR/Yj++cLmW9QzOlCSFyVB01QVE5tKkE4i4H1t7GSE
         ucMyhd/8FiRU3IH1c7keHGhwBwKrFpmPtg4jamLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 137/142] ASoC: topology: Properly unregister DAI on removal
Date:   Tue,  2 Feb 2021 14:38:20 +0100
Message-Id: <20210202133003.341783247@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit fc4cb1e15f0c66f2e37314349dc4a82bd946fbb1 upstream.

DAIs need to be removed when topology unload function is called (usually
done when component is being removed). We can't do this when device is
being removed, as structures we operate on when removing DAI can already
be freed.

Fixes: 6ae4902f2f34 ("ASoC: soc-topology: use devm_snd_soc_register_dai()")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210120152846.1703655-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -506,7 +506,7 @@ static void remove_dai(struct snd_soc_co
 {
 	struct snd_soc_dai_driver *dai_drv =
 		container_of(dobj, struct snd_soc_dai_driver, dobj);
-	struct snd_soc_dai *dai;
+	struct snd_soc_dai *dai, *_dai;
 
 	if (pass != SOC_TPLG_PASS_PCM_DAI)
 		return;
@@ -514,9 +514,9 @@ static void remove_dai(struct snd_soc_co
 	if (dobj->ops && dobj->ops->dai_unload)
 		dobj->ops->dai_unload(comp, dobj);
 
-	for_each_component_dais(comp, dai)
+	for_each_component_dais_safe(comp, dai, _dai)
 		if (dai->driver == dai_drv)
-			dai->driver = NULL;
+			snd_soc_unregister_dai(dai);
 
 	kfree(dai_drv->playback.stream_name);
 	kfree(dai_drv->capture.stream_name);
@@ -1876,7 +1876,7 @@ static int soc_tplg_dai_create(struct so
 	list_add(&dai_drv->dobj.list, &tplg->comp->dobj_list);
 
 	/* register the DAI to the component */
-	dai = devm_snd_soc_register_dai(tplg->comp->dev, tplg->comp, dai_drv, false);
+	dai = snd_soc_register_dai(tplg->comp, dai_drv, false);
 	if (!dai)
 		return -ENOMEM;
 
@@ -1884,6 +1884,7 @@ static int soc_tplg_dai_create(struct so
 	ret = snd_soc_dapm_new_dai_widgets(dapm, dai);
 	if (ret != 0) {
 		dev_err(dai->dev, "Failed to create DAI widgets %d\n", ret);
+		snd_soc_unregister_dai(dai);
 		return ret;
 	}
 


