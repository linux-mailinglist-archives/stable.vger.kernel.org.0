Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A995154A609
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353023AbiFNCQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352515AbiFNCPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:15:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAF83D1E2;
        Mon, 13 Jun 2022 19:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB175B816A6;
        Tue, 14 Jun 2022 02:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2F0C36B00;
        Tue, 14 Jun 2022 02:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172550;
        bh=4syYMxPkzIJ/qkZf+faSQz3RfpeaARsghA50qhraB/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icFefRUctHjT2dbVTz7d01h2QBq6iC1uQDwxf8U9eOj9FzfmIoR1En2PP+2rktx2t
         rvcvykeBw2R+W61KICDUmqbKrOklxCd9jT/cgT+WlgkmGc52EkS0WxMpUdKDTabaiq
         Kdm5LBWXaLHotNvWRal/fn7Nwkm1IXLacSp1hDh6NhoXsORmcAVJQ/VklOBBREpSn5
         t/r+0p2zZ0DS+SNYjsOtants6e9gl7WEmKn7jEzVQoR4Hn4vVFaBs62YOl3QoSVB5V
         poH3a2JFyNMvmjC5mE9heMS6siM1SzUwDsUQOp/xfHWLYnnI0sN8Mpv6Cj240GSFIq
         qzZPP6rdw1bPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 05/23] ASoC: cs35l36: Update digital volume TLV
Date:   Mon, 13 Jun 2022 22:08:41 -0400
Message-Id: <20220614020900.1100401-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5005a2345825eb8346546d99bfe669f73111b5c5 ]

The digital volume TLV specifies the step as 0.25dB but the actual step
of the control is 0.125dB. Update the TLV to correct this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220602162119.3393857-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l36.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l36.c b/sound/soc/codecs/cs35l36.c
index e9b5f76f27a8..aa32b8c26578 100644
--- a/sound/soc/codecs/cs35l36.c
+++ b/sound/soc/codecs/cs35l36.c
@@ -444,7 +444,8 @@ static bool cs35l36_volatile_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static DECLARE_TLV_DB_SCALE(dig_vol_tlv, -10200, 25, 0);
+static const DECLARE_TLV_DB_RANGE(dig_vol_tlv, 0, 912,
+				  TLV_DB_MINMAX_ITEM(-10200, 1200));
 static DECLARE_TLV_DB_SCALE(amp_gain_tlv, 0, 1, 1);
 
 static const char * const cs35l36_pcm_sftramp_text[] =  {
-- 
2.35.1

