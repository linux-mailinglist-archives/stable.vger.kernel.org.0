Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0432594D48
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343679AbiHPAme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347426AbiHPAkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A43318DC1C;
        Mon, 15 Aug 2022 13:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B3FD61185;
        Mon, 15 Aug 2022 20:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA03C433C1;
        Mon, 15 Aug 2022 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595935;
        bh=5e+hyuj66mgvkBpjDbdBWNeP1w9LjavneXVUc/Qsum4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3DnOFhffqp3Mj5pCYRW1hSQH7EQwLG2Ue3vMOrhq+n6lc+IvkzVcCxWDb1AvoIZ0
         Db5XXwjaEe24NVtdICrZa61KAqloh2jdHuxVowiqlkSyLeb9TmNlaq+zwMYhZBO9VW
         S8UOwrHJkQ1XKoYpH64ZaDk/2UFQWZ/dIvZNeeaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0921/1157] ASoC: codecs: wsa881x: handle timeouts in resume path
Date:   Mon, 15 Aug 2022 20:04:37 +0200
Message-Id: <20220815180516.295036825@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit cf6af24b54903f9f70c29b3e5b19cb72cc862d60 ]

Currently we do not check if SoundWire slave initialization timeout
expired before continuing to access its registers.

Its possible that the registers are not accessible if timeout is
expired. Handle this by returning timeout in resume path.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Fixes: 8dd552458361 ("ASoC: codecs: wsa881x: add runtime pm support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220630130023.9308-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index f3a56f3ce487..02a438c6c4c7 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1175,11 +1175,17 @@ static int __maybe_unused wsa881x_runtime_resume(struct device *dev)
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 	struct regmap *regmap = dev_get_regmap(dev, NULL);
 	struct wsa881x_priv *wsa881x = dev_get_drvdata(dev);
+	unsigned long time;
 
 	gpiod_direction_output(wsa881x->sd_n, 1);
 
-	wait_for_completion_timeout(&slave->initialization_complete,
-				    msecs_to_jiffies(WSA881X_PROBE_TIMEOUT));
+	time = wait_for_completion_timeout(&slave->initialization_complete,
+					   msecs_to_jiffies(WSA881X_PROBE_TIMEOUT));
+	if (!time) {
+		dev_err(dev, "Initialization not complete, timed out\n");
+		gpiod_direction_output(wsa881x->sd_n, 0);
+		return -ETIMEDOUT;
+	}
 
 	regcache_cache_only(regmap, false);
 	regcache_sync(regmap);
-- 
2.35.1



