Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74449A442
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371293AbiAYAH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2366197AbiAXXwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717ABC07A95D;
        Mon, 24 Jan 2022 13:45:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D3B4B81142;
        Mon, 24 Jan 2022 21:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53345C340E4;
        Mon, 24 Jan 2022 21:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060708;
        bh=nf9RogTdgf5rF0q38xnhspYQQDGnFe/Ue5b2fTj9+SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lX5NfEs7uY3tpE/kkWgJPZsa1KP+ccqEJoRLpnr4IN/+sNYkN4VYSRr86bb5jsRWq
         1W2P3nuElQEHus5UG9aQ3j22s9mkn0y0d/h5guUdqq0sOxTMettM7IZ2T4SiAmCxcA
         NnJjFBXKAj2RgR8izBkWz/oJ65Zji3QPZ5BTHs4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 1037/1039] ASoC: SOF: free widgets in sof_tear_down_pipelines() for static pipelines
Date:   Mon, 24 Jan 2022 19:47:06 +0100
Message-Id: <20220124184200.145139407@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit b2ebcf42a48f4560862bb811f3268767d17ebdcd upstream.

Free widgets for static pipelines in sof_tear_down_pipelines().
But this feature is unavailable in older firmware with ABI < 3.19.
Just reset widget use_count's for this case. This would ensure that
the secondary cores enabled required for topology setup are powered
down properly before the primary core is powered off during
system suspend.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211119192621.4096077-8-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -665,11 +665,12 @@ int sof_set_up_pipelines(struct snd_sof_
 }
 
 /*
- * This function doesn't free widgets during suspend. It only resets the set up status for all
- * routes and use_count for all widgets.
+ * For older firmware, this function doesn't free widgets for static pipelines during suspend.
+ * It only resets use_count for all widgets.
  */
 int sof_tear_down_pipelines(struct snd_sof_dev *sdev, bool verify)
 {
+	struct sof_ipc_fw_version *v = &sdev->fw_ready.version;
 	struct snd_sof_widget *swidget;
 	struct snd_sof_route *sroute;
 	int ret;
@@ -681,8 +682,14 @@ int sof_tear_down_pipelines(struct snd_s
 	 * loading the sound card unavailable to open PCMs.
 	 */
 	list_for_each_entry_reverse(swidget, &sdev->widget_list, list) {
-		if (!verify) {
+		if (swidget->dynamic_pipeline_widget)
+			continue;
+
+		/* Do not free widgets for static pipelines with FW ABI older than 3.19 */
+		if (!verify && !swidget->dynamic_pipeline_widget &&
+		    v->abi_version < SOF_ABI_VER(3, 19, 0)) {
 			swidget->use_count = 0;
+			swidget->complete = 0;
 			continue;
 		}
 


