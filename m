Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860F76B430A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjCJOKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjCJOJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE6B11786F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86A6F61948
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93935C4339E;
        Fri, 10 Mar 2023 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457346;
        bh=I9LMU2nZLKl9c1k1I1vIBYQRQYDE/9gFVnCwbePCPKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBnd+4VjeuvvdLdvrR8K91YmbyFlT9vHfSjVKY64OwGVNcO3h1PhnpHvENaGKTTL5
         MyRGCWSPoy4YfS+hGJtoXo0ot/DdfwXKxE+VK+rgwK7COxQz4RNh3u6d7MP3zEshy3
         CNtRmzeiytbo8rRYkdRRWRIuH+9/g8Z2kDkaZqgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/200] ASoC: apple: mca: Fix SERDES reset sequence
Date:   Fri, 10 Mar 2023 14:38:33 +0100
Message-Id: <20230310133720.351076307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit d8b3e396088d787771f19fd3b7949e080dc31d6f ]

Fix the reset sequence of reads and writes that we invoke from within
the early trigger. It looks like there never was a SERDES_CONF_SOME_RST
bit that should be involved in the reset sequence, and its presence in
the driver code is a mistake from earlier.

Instead, the reset sequence should go as follows: We should switch the
the SERDES unit's SYNC_SEL mux to the value of 7 (so outside the range
of 1...6 representing cluster's SYNCGEN units), then raise the RST bit
in SERDES_STATUS and wait for it to clear.

Properly resetting the SERDES unit fixes frame desynchronization hazard
in case of long frames (longer than 4 used slots). The desynchronization
manifests itself by rotating the PCM channels.

Fixes: 3df5d0d97289 ("ASoC: apple: mca: Start new platform driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224153302.45365-2-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index 9cceeb2599524..aea08c7b2ee85 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -101,7 +101,6 @@
 #define SERDES_CONF_UNK3	BIT(14)
 #define SERDES_CONF_NO_DATA_FEEDBACK	BIT(15)
 #define SERDES_CONF_SYNC_SEL	GENMASK(18, 16)
-#define SERDES_CONF_SOME_RST	BIT(19)
 #define REG_TX_SERDES_BITSTART	0x08
 #define REG_RX_SERDES_BITSTART	0x0c
 #define REG_TX_SERDES_SLOTMASK	0x0c
@@ -203,15 +202,24 @@ static void mca_fe_early_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, 0));
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, 7));
 		mca_modify(cl, serdes_unit + REG_SERDES_STATUS,
 			   SERDES_STATUS_EN | SERDES_STATUS_RST,
 			   SERDES_STATUS_RST);
-		mca_modify(cl, serdes_conf, SERDES_CONF_SOME_RST,
-			   SERDES_CONF_SOME_RST);
-		readl_relaxed(cl->base + serdes_conf);
-		mca_modify(cl, serdes_conf, SERDES_STATUS_RST, 0);
+		/*
+		 * Experiments suggest that it takes at most ~1 us
+		 * for the bit to clear, so wait 2 us for good measure.
+		 */
+		udelay(2);
 		WARN_ON(readl_relaxed(cl->base + serdes_unit + REG_SERDES_STATUS) &
 			SERDES_STATUS_RST);
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, 0));
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, cl->no + 1));
 		break;
 	default:
 		break;
-- 
2.39.2



