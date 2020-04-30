Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055781BFA05
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgD3Nuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgD3Nuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41FBC208DB;
        Thu, 30 Apr 2020 13:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254654;
        bh=wKg3mdRc7QvO4DqaiEtjwc6EMIbVoFS3vQY/Sg+NFzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4/PrBrnxcRrBqTBfo4gDYySKSHAvnz87UzGngk+yBUjTG1klCP9+5ioXdTcaHf3v
         NWBGsBBtCYLV2+Um86ePCy9wG8NDl8qtJTp8+eArWieUtgiyiK+i/y4Tc6zbdQwyIe
         QGJILX35lt8QoJ9bOZHo1mJK788zyVIr9OiDow6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 08/79] ASoC: topology: Check return value of soc_tplg_create_tlv
Date:   Thu, 30 Apr 2020 09:49:32 -0400
Message-Id: <20200430135043.19851-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

