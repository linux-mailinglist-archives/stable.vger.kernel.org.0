Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01426C568C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjCVUHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjCVUGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:06:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72032580EF;
        Wed, 22 Mar 2023 13:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06652622B4;
        Wed, 22 Mar 2023 20:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BF5C433A0;
        Wed, 22 Mar 2023 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515227;
        bh=k+hmGhSaD1+QaJ7ZakF1ukiTvaTebvpE8t6aMcJUf28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bigz0qnTTorcAD6Yg4qL5KvBO9GtSD9mAPWi9caoxRJHuJ2t9rdKCqqucvOnpb2k2
         0btBuESJx2pkt+fZO6RhTVwcNfAQYfqWcBkcIxHd4vD2j+eFVlNOOpVVGXg//lhkQd
         KBWJpy8pQ5Tr+fMVWEZEzA/R2AFfdHLKKRAp2L/r2CMHHyjwbPIQBkyfMUaQ9VJ0P0
         ql9xA9nimX0d/VVs80RN7Dt1Xvdb0Dl44wv2ipYFQZuggUgKufef84Qn32fQ+w+3hT
         QeLZZc+N8HvqjWqahmp4sLbjswtU5dHX/qVtawiwzEIt3OyveZXb0pcKcA/+5l+DuS
         L7r0flaHf/h3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Curtis Malainey <curtis@malainey.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 10/34] ASoC: SOF: ipc3: Check for upper size limit for the received message
Date:   Wed, 22 Mar 2023 15:59:02 -0400
Message-Id: <20230322195926.1996699-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 989a3e4479177d0f4afab8be1960731bc0ffbbd0 ]

The sof_ipc3_rx_msg() checks for minimum size of a new rx message but it is
missing the check for upper limit.
Corrupted or compromised firmware might be able to take advantage of this
to cause out of bounds reads outside of the message area.

Reported-by: Curtis Malainey <cujomalainey@chromium.org>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Curtis Malainey <curtis@malainey.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307114917.5124-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc3.c b/sound/soc/sof/ipc3.c
index b28af3a48b707..60b96b0c2412f 100644
--- a/sound/soc/sof/ipc3.c
+++ b/sound/soc/sof/ipc3.c
@@ -970,8 +970,9 @@ static void sof_ipc3_rx_msg(struct snd_sof_dev *sdev)
 		return;
 	}
 
-	if (hdr.size < sizeof(hdr)) {
-		dev_err(sdev->dev, "The received message size is invalid\n");
+	if (hdr.size < sizeof(hdr) || hdr.size > SOF_IPC_MSG_MAX_SIZE) {
+		dev_err(sdev->dev, "The received message size is invalid: %u\n",
+			hdr.size);
 		return;
 	}
 
-- 
2.39.2

