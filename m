Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D1F49A321
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366135AbiAXXwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844758AbiAXXKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:10:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42967C0A0284;
        Mon, 24 Jan 2022 13:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F75611C8;
        Mon, 24 Jan 2022 21:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E48C340E5;
        Mon, 24 Jan 2022 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059100;
        bh=4mLwih6tINbnvNP9necaLO4eAyc9DYsXQyBja+Tq//0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jckyOONsxDprXKzOcQlMKnJgyUgovA5pOaYf09GCh/Ai1MporJpR50kJpN3A2gDSo
         4hJYt+bQ/GgUImRWbB20jX2LhuMuSaCx+qdF3rOEVe+1I+kJjg/tAQNiYVNrtVIFWC
         wRmjwEljWB80rvf/QdXHafy9aDAqakV+agZI7Uvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0477/1039] ASoC: SOF: Intel: fix build issue related to CODEC_PROBE_ENTRIES
Date:   Mon, 24 Jan 2022 19:37:46 +0100
Message-Id: <20220124184141.307544345@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 9a83dfcc5ae8230fbf12b63e281d5bb8450ec0e7 ]

Fix following error:
sound/soc/sof/intel/hda-codec.c:132:35: error: use of undeclared identifier 'CODEC_PROBE_RETRIES'

Found with config: i386-randconfig-r033-20211202
(https://download.01.org/0day-ci/archive/20211203/202112031943.Twg19fWT-lkp@intel.com/config)

Fixes: 046aede2f847 ("ASoC: SOF: Intel: Retry codec probing if it fails")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211203154721.923496-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 13cd96e6724a4..2f3f4a733d9e6 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -20,9 +20,10 @@
 #include "../../codecs/hdac_hda.h"
 #endif /* CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC */
 
+#define CODEC_PROBE_RETRIES	3
+
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 #define IDISP_VID_INTEL	0x80860000
-#define CODEC_PROBE_RETRIES 3
 
 /* load the legacy HDA codec driver */
 static int request_codec_module(struct hda_codec *codec)
-- 
2.34.1



