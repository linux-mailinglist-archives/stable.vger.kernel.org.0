Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15569461F1B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379547AbhK2Snx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:43:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46576 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379619AbhK2Slh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:41:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28D29B815DE;
        Mon, 29 Nov 2021 18:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B47AC53FAD;
        Mon, 29 Nov 2021 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211096;
        bh=gbB8bVe2nIsnzlVycJAWYfOxGh+bgcj0AMdj2HeRu9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvoyTQzJ+fAeKCcrOVJD/zkEZVG+OAtpEA3yern9Lfivp0f7tfFG3P3cSGmGz9KVH
         wA4IBlTGoFG65f+cIEhvFC7kcsd+GWCWTaA0XzGIXZ2IdFe+nlV7ded2qg4cDXNH7w
         74fanLrxFaBF0A5rUzzq+FMIQRDG9Godpcx5HWGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/179] ALSA: intel-dsp-config: add quirk for JSL devices based on ES8336 codec
Date:   Mon, 29 Nov 2021 19:18:17 +0100
Message-Id: <20211129181722.329470320@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit fa9730b4f28b7bd183d28a0bf636ab7108de35d7 ]

These devices are based on an I2C/I2S device, we need to force the use
of the SOF driver otherwise the legacy HDaudio driver will be loaded -
only HDMI will be supported.

We previously added support for other Intel platforms but missed
JasperLake.

BugLink: https://github.com/thesofproject/linux/issues/3210
Fixes: 9d36ceab9415 ('ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211027023254.24955-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index b9ac9e9e45a48..10a0bffc3cf6c 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -299,6 +299,15 @@ static const struct config_entry config_table[] = {
 	},
 #endif
 
+/* JasperLake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_JASPERLAKE)
+	{
+		.flags = FLAG_SOF,
+		.device = 0x4dc8,
+		.codec_hid = "ESSX8336",
+	},
+#endif
+
 /* Tigerlake */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_TIGERLAKE)
 	{
-- 
2.33.0



