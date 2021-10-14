Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937D242DD49
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhJNPGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233504AbhJNPEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2547F611AD;
        Thu, 14 Oct 2021 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223637;
        bh=0lnmFkKEGL8qe77uI9RJxhhWy2zee8GFecR+3m+fJi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jO+VbSLKsmh5D9StgTZywn7fCIRFAVWTZVQ2CyTfDo05VsYcxXz41p2Mht7dMPx8o
         87nQ42g3zHkIFVOhhPYKgM7OVPyPF9VZNpyxIkFS9Mgv4xSACD8noAPeihz7n5V8Dt
         XM2PCu5+ZuW1hsbKs12imWgmCmY4ikrb71a4lT0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Herbert <marc.herbert@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 10/30] ASoC: SOF: loader: release_firmware() on load failure to avoid batching
Date:   Thu, 14 Oct 2021 16:54:15 +0200
Message-Id: <20211014145209.862805546@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



