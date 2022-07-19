Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4220579EFA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243226AbiGSNIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243055AbiGSNIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F29ABB8C7;
        Tue, 19 Jul 2022 05:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9251360693;
        Tue, 19 Jul 2022 12:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AC4C341C6;
        Tue, 19 Jul 2022 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233676;
        bh=pOS5a7puDGZ/iWqaJdM1223AaUj8iUfebzf3eXEB9Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2k6Y92IPJBt/pJplCtMjv+iVf55V8YgEYd3A0epv6wMbp82zadCxe13/FDQlucdZC
         2SjY6HyfvqABI6Sv+BEFsE41pGI0YwG/dCLLniePOAsUxGmzBy6Rxq/F3sJkPSMiRc
         j6cV4bPe1bmi9rv262FVIPzTisltDrnvl03PLVeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 203/231] ASoC: cs35l41: Add ASP TX3/4 source to register patch
Date:   Tue, 19 Jul 2022 13:54:48 +0200
Message-Id: <20220719114731.066776089@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 46b0d050c8c7df6dfb2c376aaa149bf2cfc5ca3e ]

The mixer controls for ASP TX3/4 are set to values that are not included
in their enumeration control. This will cause spurious event
notifications when the controls are first changed, as the register value
changes whilst the actual visible enumeration value does not. Use the
register patch to set them to a known value, zero, which equates to zero
fill, thereby avoiding the spurious notifications.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-lib.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l41-lib.c b/sound/soc/codecs/cs35l41-lib.c
index 17cf782f39af..538b5c4d3abf 100644
--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -36,8 +36,8 @@ static const struct reg_default cs35l41_reg[] = {
 	{ CS35L41_DAC_PCM1_SRC,			0x00000008 },
 	{ CS35L41_ASP_TX1_SRC,			0x00000018 },
 	{ CS35L41_ASP_TX2_SRC,			0x00000019 },
-	{ CS35L41_ASP_TX3_SRC,			0x00000020 },
-	{ CS35L41_ASP_TX4_SRC,			0x00000021 },
+	{ CS35L41_ASP_TX3_SRC,			0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,			0x00000000 },
 	{ CS35L41_DSP1_RX1_SRC,			0x00000008 },
 	{ CS35L41_DSP1_RX2_SRC,			0x00000009 },
 	{ CS35L41_DSP1_RX3_SRC,			0x00000018 },
@@ -643,6 +643,8 @@ static const struct reg_sequence cs35l41_reva0_errata_patch[] = {
 	{ CS35L41_DSP1_XM_ACCEL_PL0_PRI, 0x00000000 },
 	{ CS35L41_PWR_CTRL2,		 0x00000000 },
 	{ CS35L41_AMP_GAIN_CTRL,	 0x00000000 },
+	{ CS35L41_ASP_TX3_SRC,		 0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,		 0x00000000 },
 };
 
 static const struct reg_sequence cs35l41_revb0_errata_patch[] = {
@@ -654,6 +656,8 @@ static const struct reg_sequence cs35l41_revb0_errata_patch[] = {
 	{ CS35L41_DSP1_XM_ACCEL_PL0_PRI, 0x00000000 },
 	{ CS35L41_PWR_CTRL2,		 0x00000000 },
 	{ CS35L41_AMP_GAIN_CTRL,	 0x00000000 },
+	{ CS35L41_ASP_TX3_SRC,		 0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,		 0x00000000 },
 };
 
 static const struct reg_sequence cs35l41_revb2_errata_patch[] = {
@@ -665,6 +669,8 @@ static const struct reg_sequence cs35l41_revb2_errata_patch[] = {
 	{ CS35L41_DSP1_XM_ACCEL_PL0_PRI, 0x00000000 },
 	{ CS35L41_PWR_CTRL2,		 0x00000000 },
 	{ CS35L41_AMP_GAIN_CTRL,	 0x00000000 },
+	{ CS35L41_ASP_TX3_SRC,		 0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,		 0x00000000 },
 };
 
 static const struct cs35l41_otp_map_element_t cs35l41_otp_map_map[] = {
-- 
2.35.1



