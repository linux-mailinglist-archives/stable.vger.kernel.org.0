Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0342288E
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhJENxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235483AbhJENwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB481615A3;
        Tue,  5 Oct 2021 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441853;
        bh=0lnmFkKEGL8qe77uI9RJxhhWy2zee8GFecR+3m+fJi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfCIk6OgsF2b0rEbrF2SbpuW35kaUIDcnjlqEbV1cXIrYtTobqCUJI9RebruASY2/
         R+AL77NiVbtaUXOM0hsP95SwtCsziqI35iNDTZDAuI3dsJKvOeDJ4Q4jMmxNYItoC+
         sSz9jv1eVa90BA1u7y40/JuFYeFRKKG2CyB9XdZ/zyKTUIr+VHqx9Du+V93KOTWs27
         XziICADZtdNuLMdWNrKwLL2wBQiFCzZWPW0/PANp+CbDbrDppOHhemt4JgtC0WfbrP
         D0Qgr9AeONOfog+/yOLDg6KDsXWRERC0tPBoJxFXM4QwCFLBgzHDEp4Z45gTnuP+aI
         JdsL4VNIzMwZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Herbert <marc.herbert@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        kai.vehmanen@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 15/40] ASoC: SOF: loader: release_firmware() on load failure to avoid batching
Date:   Tue,  5 Oct 2021 09:49:54 -0400
Message-Id: <20211005135020.214291-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Herbert <marc.herbert@intel.com>

[ Upstream commit 8a8e1813ffc35111fc0b6db49968ceb0e1615ced ]

Invoke release_firmware() when the firmware fails to boot in
sof_probe_continue().

The request_firmware() framework must be informed of failures in
sof_probe_continue() otherwise its internal "batching"
feature (different from caching) cached the firmware image
forever. Attempts to correct the file in /lib/firmware/ were then
silently and confusingly ignored until the next reboot. Unloading the
drivers did not help because from their disconnected perspective the
firmware had failed so there was nothing to release.

Also leverage the new snd_sof_fw_unload() function to simplify the
snd_sof_device_remove() function.

Signed-off-by: Marc Herbert <marc.herbert@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20210916085008.28929-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c   | 4 +---
 sound/soc/sof/loader.c | 2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 3e4dd4a86363..59d0d7b2b55c 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -371,7 +371,6 @@ int snd_sof_device_remove(struct device *dev)
 			dev_warn(dev, "error: %d failed to prepare DSP for device removal",
 				 ret);
 
-		snd_sof_fw_unload(sdev);
 		snd_sof_ipc_free(sdev);
 		snd_sof_free_debug(sdev);
 		snd_sof_free_trace(sdev);
@@ -394,8 +393,7 @@ int snd_sof_device_remove(struct device *dev)
 		snd_sof_remove(sdev);
 
 	/* release firmware */
-	release_firmware(pdata->fw);
-	pdata->fw = NULL;
+	snd_sof_fw_unload(sdev);
 
 	return 0;
 }
diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index 2b38a77cd594..9c3f251a0dd0 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -880,5 +880,7 @@ EXPORT_SYMBOL(snd_sof_run_firmware);
 void snd_sof_fw_unload(struct snd_sof_dev *sdev)
 {
 	/* TODO: support module unloading at runtime */
+	release_firmware(sdev->pdata->fw);
+	sdev->pdata->fw = NULL;
 }
 EXPORT_SYMBOL(snd_sof_fw_unload);
-- 
2.33.0

