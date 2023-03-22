Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524636C55A5
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjCVT75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjCVT7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170014D29B;
        Wed, 22 Mar 2023 12:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9219B81DC6;
        Wed, 22 Mar 2023 19:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A9CC4339E;
        Wed, 22 Mar 2023 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515084;
        bh=QHiqBaDd7TKi3Fgb4EqKzNbkcwRu76OmI/eB7btnxU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stl1Dk4j4cHTIZS18wpnhtdl4ZA5BQeWyYOS5OWLcDPF5vjzo5kEzmoDsL66xyCZW
         Vm48bfnkc4xkJNd1B4AUoLdXBrUtGIyyDNL75027egR+mMGixuZqyoslfajPKu1TmT
         MbDknoImBln26ObRFhndFKQ1QIcOYOWzfvkTNTkqN3GZphOLzgt0hoQ9v99NWUVd0/
         kXlug8aHRfA4NwUWID3wobo11dwRcF9PnzXaZRpjhczBNSYiBifIYVmjyUdJjiT0MO
         UT9DUQoRHe99z/GwgZUeC4+1VPULuotrfKPkezDAO1v+Jy0jlrJnX7PF7Zr6MEk58i
         vOAC8i21KSD3g==
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
Subject: [PATCH AUTOSEL 6.2 14/45] ASoC: SOF: ipc3: Check for upper size limit for the received message
Date:   Wed, 22 Mar 2023 15:56:08 -0400
Message-Id: <20230322195639.1995821-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
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
index 1fef4dcc09368..fde8af5a1f485 100644
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

