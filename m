Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C3B551B27
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiFTNLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343919AbiFTNJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F761AF1C;
        Mon, 20 Jun 2022 06:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C02614AB;
        Mon, 20 Jun 2022 13:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1790C3411C;
        Mon, 20 Jun 2022 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730078;
        bh=4syYMxPkzIJ/qkZf+faSQz3RfpeaARsghA50qhraB/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lgrSapbFw0O0TPQsGXn1y7I6gYXgCQVbUcC5El8l02UtAZ8G4GLazMgGosc7gO2s
         /RRWmnk7Amqt9PoVb3bZo0VifOMnDjEqAzUVRRajEiOy6Tt+y2h7SPiJjYEcJ8fPcU
         p+OTGmfBLk0W7J9uFDBVJ7gTABRaYbhweXDLp2J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/84] ASoC: cs35l36: Update digital volume TLV
Date:   Mon, 20 Jun 2022 14:50:32 +0200
Message-Id: <20220620124721.165608230@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



