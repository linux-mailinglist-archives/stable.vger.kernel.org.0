Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95C592397
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiHNQWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbiHNQVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E212EF;
        Sun, 14 Aug 2022 09:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A03260F40;
        Sun, 14 Aug 2022 16:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A916C433D7;
        Sun, 14 Aug 2022 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494022;
        bh=XMqlULsVRDZW+IEUfiphA3cJNCqcrWzjUawBkqNX6W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzc8pajroHF5mNigjW37/vIYBlwRxXlb/jIbQw+4eM/6hhiviTz5fvAZPefcJJsE6
         RZs4FPbJh59rOI+oL9UEmDY9pXCHtMd+wjdUTNKal7ZDcl9PMn2vRUbcmWOxVxjnJ6
         fgf29tjq44eHtxThbLpJouzoTWUjOheTov5voOCVt40GOhVlz4RyfTM3BjCkjjEu8/
         8OIcMQ3i4OGMiMqiwjslrzWcaaZnxNVl756FKvZwSVZLiF5p9g9ldklZhFBpExAwGv
         +1WnsCMkCqs0+zx3rWNramj1xE/CoGtwarfFBbsfDCmKBA0jym7EDG2QA0sabVtZlL
         POvegh8R4Qw8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 14/48] ASoC: SOF: sof-client-probes: Only load the driver if IPC3 is used
Date:   Sun, 14 Aug 2022 12:19:07 -0400
Message-Id: <20220814161943.2394452-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 9b93eda355089b36482f7a2f134bdd24be70f907 ]

The current implementation of probes only supports IPC3 and should not be
loaded for other IPC implementation.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220712131022.1124-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-client-probes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/sof-client-probes.c b/sound/soc/sof/sof-client-probes.c
index 34e6bd356e71..60e4250fac87 100644
--- a/sound/soc/sof/sof-client-probes.c
+++ b/sound/soc/sof/sof-client-probes.c
@@ -693,6 +693,10 @@ static int sof_probes_client_probe(struct auxiliary_device *auxdev,
 	if (!sof_probes_enabled)
 		return -ENXIO;
 
+	/* only ipc3 is supported */
+	if (sof_client_get_ipc_type(cdev) != SOF_IPC)
+		return -ENXIO;
+
 	if (!dev->platform_data) {
 		dev_err(dev, "missing platform data\n");
 		return -ENODEV;
-- 
2.35.1

