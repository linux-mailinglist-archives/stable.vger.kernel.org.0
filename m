Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD324DE0C
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHURZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbgHUQPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E929522B4B;
        Fri, 21 Aug 2020 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026521;
        bh=EJJez6UPPbajUEmbkwY0h8McdlMhZ6j/R+FW9Mk8Q0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDPDiIgSo3JKgcHY0PofC9eYjlcnIqcafoOB8BRrRONW5iHBX/tPRroGMy7bi363I
         K8qjAHGCcVa37f4WPONs3OviaapTPrioTOLqf4x8FKM4O4FA9UgCuetTPr76mexY1o
         7WKIs3tYxTJO1UmdZDqSDi6Vx1GXLeUN5RFENHjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 45/62] ASoC: Intel: sof_sdw_rt711: remove properties in card remove
Date:   Fri, 21 Aug 2020 12:14:06 -0400
Message-Id: <20200821161423.347071-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit cf0418cd06ce42fcf35beb33e315b5a77e596926 ]

The rt711 jack detection properties are set from the machine drivers
during the card probe, as done in other ASoC examples.

KASAN reports a use-after-free error when unbinding drivers due to a
confusing sequence between the ACPI core, the device core and the
SoundWire device cleanups.

Rather than fixing this sequence, follow the recommendation to have
the same caller add and remove properties, add an explicit
device_remove_properties() in the card .remove() callback.

In future patches the use of device_add/remove_properties will be
replaced by a direct handling of a swnode, but the sequence will
remain the same.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200717211337.31956-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c        |  1 +
 sound/soc/intel/boards/sof_sdw_common.h |  1 +
 sound/soc/intel/boards/sof_sdw_rt711.c  | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 1bfd9613449e9..95a119a2d354e 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -184,6 +184,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.direction = {true, true},
 		.dai_name = "rt711-aif1",
 		.init = sof_sdw_rt711_init,
+		.exit = sof_sdw_rt711_exit,
 	},
 	{
 		.id = 0x1308,
diff --git a/sound/soc/intel/boards/sof_sdw_common.h b/sound/soc/intel/boards/sof_sdw_common.h
index 69b363b8a6869..fdd2385049e1e 100644
--- a/sound/soc/intel/boards/sof_sdw_common.h
+++ b/sound/soc/intel/boards/sof_sdw_common.h
@@ -84,6 +84,7 @@ int sof_sdw_rt711_init(const struct snd_soc_acpi_link_adr *link,
 		       struct snd_soc_dai_link *dai_links,
 		       struct sof_sdw_codec_info *info,
 		       bool playback);
+int sof_sdw_rt711_exit(struct device *dev, struct snd_soc_dai_link *dai_link);
 
 /* RT700 support */
 int sof_sdw_rt700_init(const struct snd_soc_acpi_link_adr *link,
diff --git a/sound/soc/intel/boards/sof_sdw_rt711.c b/sound/soc/intel/boards/sof_sdw_rt711.c
index d4d75c8dc6b78..0cb9f1c1f8676 100644
--- a/sound/soc/intel/boards/sof_sdw_rt711.c
+++ b/sound/soc/intel/boards/sof_sdw_rt711.c
@@ -133,6 +133,21 @@ static int rt711_rtd_init(struct snd_soc_pcm_runtime *rtd)
 	return ret;
 }
 
+int sof_sdw_rt711_exit(struct device *dev, struct snd_soc_dai_link *dai_link)
+{
+	struct device *sdw_dev;
+
+	sdw_dev = bus_find_device_by_name(&sdw_bus_type, NULL,
+					  dai_link->codecs[0].name);
+	if (!sdw_dev)
+		return -EINVAL;
+
+	device_remove_properties(sdw_dev);
+	put_device(sdw_dev);
+
+	return 0;
+}
+
 int sof_sdw_rt711_init(const struct snd_soc_acpi_link_adr *link,
 		       struct snd_soc_dai_link *dai_links,
 		       struct sof_sdw_codec_info *info,
-- 
2.25.1

