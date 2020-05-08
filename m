Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1651CACF9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgEHM6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbgEHMzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E61924969;
        Fri,  8 May 2020 12:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942502;
        bh=wKg3mdRc7QvO4DqaiEtjwc6EMIbVoFS3vQY/Sg+NFzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6WlXX/mxZugOoGUHl6O1mHjoakHKV3ER8+4bqeSI42NVADQxHtvRaY/lfCBU02a0
         v04Qq5Xz1TcWC0osk65g9fdbkeM/gcyTGX8vsdXDf3JMYnuzqPcZYE0Yw9ukK7kFTQ
         0Z7D1+NRBwLvctKXKP2PeeBd5rd15njdrvsEgABE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 04/49] ASoC: topology: Check return value of soc_tplg_create_tlv
Date:   Fri,  8 May 2020 14:35:21 +0200
Message-Id: <20200508123043.485099827@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 482db55ae87f3749db05810a38b1d618dfd4407c ]

Function soc_tplg_create_tlv can fail, so we should check if it succeded
or not and proceed appropriately.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200327204729.397-3-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 7a7c427de95d6..5d974a36cdc92 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -894,7 +894,13 @@ static int soc_tplg_dmixer_create(struct soc_tplg *tplg, unsigned int count,
 		}
 
 		/* create any TLV data */
-		soc_tplg_create_tlv(tplg, &kc, &mc->hdr);
+		err = soc_tplg_create_tlv(tplg, &kc, &mc->hdr);
+		if (err < 0) {
+			dev_err(tplg->dev, "ASoC: failed to create TLV %s\n",
+				mc->hdr.name);
+			kfree(sm);
+			continue;
+		}
 
 		/* pass control to driver for optional further init */
 		err = soc_tplg_init_kcontrol(tplg, &kc,
@@ -1355,7 +1361,13 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_dmixer_create(
 		}
 
 		/* create any TLV data */
-		soc_tplg_create_tlv(tplg, &kc[i], &mc->hdr);
+		err = soc_tplg_create_tlv(tplg, &kc[i], &mc->hdr);
+		if (err < 0) {
+			dev_err(tplg->dev, "ASoC: failed to create TLV %s\n",
+				mc->hdr.name);
+			kfree(sm);
+			continue;
+		}
 
 		/* pass control to driver for optional further init */
 		err = soc_tplg_init_kcontrol(tplg, &kc[i],
-- 
2.20.1



