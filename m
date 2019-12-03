Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30338111FA1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfLCXKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbfLCWmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB3920866;
        Tue,  3 Dec 2019 22:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412925;
        bh=eJH0z9YV52yUow8v5Zbm7E8SDnsfdte/C1UBeSg0ZCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCNJyaOu8LR2TiI/20JUNFRHyFfhOiCNMNJfB16Pb/04MgSlwiQ97/yFbP2ChiZi7
         MI5WKp40DcrMegSFxfdDnWNLQaXQp3JH9BBkER3lDjYwtJF4YMiGFRSgorT8E8XM+D
         oDi107jvpgk3jln1YtaXr7BRbDbaLHMtf46mgAaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 042/135] ASoC: hdac_hda: fix race in device removal
Date:   Tue,  3 Dec 2019 23:34:42 +0100
Message-Id: <20191203213015.066241334@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 5dc7d5bc9627eb26d33c7c7eefc467cf217f9326 ]

When ASoC card instance is removed containing a HDA codec,
hdac_hda_codec_remove() may run in parallel with codec resume.
This will cause problems if the HDA link is freed with
snd_hdac_ext_bus_link_put() while the codec is still in
middle of its resume process.

To fix this, change the order such that pm_runtime_disable()
is called before the link is freed. This will ensure any
pending runtime PM action is completed before proceeding
to free the link.

This issue can be easily hit with e.g. SOF driver by loading and
unloading the drivers.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191101170635.26389-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 91242b6f8ea7a..4570f662fb48b 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -410,8 +410,8 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
-	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 	pm_runtime_disable(&hdev->dev);
+	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.20.1



