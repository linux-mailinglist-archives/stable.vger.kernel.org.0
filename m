Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8058E5412DA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357039AbiFGTyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358516AbiFGTwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC7DBDA24;
        Tue,  7 Jun 2022 11:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D02AB8237B;
        Tue,  7 Jun 2022 18:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD8C385A2;
        Tue,  7 Jun 2022 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626052;
        bh=y0JC6v+FcEvZLcllLY+AqmUU60NKF5q7zJLtbIBvJ8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiJlesYufh/toHeGfGXgbLU7M5JWPhAyyz0ZHzvJO9jHimHk5ACXIhNkS2qxepC7C
         lsxaodL762DpOHKtMFSHzYhRrlOZL9UCvOvjHgf7EH8IYq0+X6GAKvgEwn+37iwWC6
         aJzG1639izV+qjOdnpW1lsHZHlUSYqWUpbGUHh0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Hui Wang <hui.wang@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 239/772] ASoC: cs35l41: Fix an out-of-bounds access in otp_packed_element_t
Date:   Tue,  7 Jun 2022 18:57:11 +0200
Message-Id: <20220607164956.073616721@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 9f342904216f378e88008bb0ce1ae200a4b99fe8 ]

The CS35L41_NUM_OTP_ELEM is 100, but only 99 entries are defined in
the array otp_map_1/2[CS35L41_NUM_OTP_ELEM], this will trigger UBSAN
to report a shift-out-of-bounds warning in the cs35l41_otp_unpack()
since the last entry in the array will result in GENMASK(-1, 0).

UBSAN reports this problem:
 UBSAN: shift-out-of-bounds in /home/hwang4/build/jammy/jammy/sound/soc/codecs/cs35l41-lib.c:836:8
 shift exponent 64 is too large for 64-bit type 'long unsigned int'
 CPU: 10 PID: 595 Comm: systemd-udevd Not tainted 5.15.0-23-generic #23
 Hardware name: LENOVO \x02MFG_IN_GO/\x02MFG_IN_GO, BIOS N3GET19W (1.00 ) 03/11/2022
 Call Trace:
  <TASK>
  show_stack+0x52/0x58
  dump_stack_lvl+0x4a/0x5f
  dump_stack+0x10/0x12
  ubsan_epilogue+0x9/0x45
  __ubsan_handle_shift_out_of_bounds.cold+0x61/0xef
  ? regmap_unlock_mutex+0xe/0x10
  cs35l41_otp_unpack.cold+0x1c6/0x2b2 [snd_soc_cs35l41_lib]
  cs35l41_hda_probe+0x24f/0x33a [snd_hda_scodec_cs35l41]
  cs35l41_hda_i2c_probe+0x65/0x90 [snd_hda_scodec_cs35l41_i2c]
  ? cs35l41_hda_i2c_remove+0x20/0x20 [snd_hda_scodec_cs35l41_i2c]
  i2c_device_probe+0x252/0x2b0

Fixes: 6450ef559056 ("ASoC: cs35l41: CS35L41 Boosted Smart Amplifier")
Reviewed-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20220328123535.50000-2-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l41.h        |  1 -
 sound/soc/codecs/cs35l41-lib.c | 14 +++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/sound/cs35l41.h b/include/sound/cs35l41.h
index bf7f9a9aeba0..9341130257ea 100644
--- a/include/sound/cs35l41.h
+++ b/include/sound/cs35l41.h
@@ -536,7 +536,6 @@
 
 #define CS35L41_MAX_CACHE_REG		36
 #define CS35L41_OTP_SIZE_WORDS		32
-#define CS35L41_NUM_OTP_ELEM		100
 
 #define CS35L41_VALID_PDATA		0x80000000
 #define CS35L41_NUM_SUPPLIES            2
diff --git a/sound/soc/codecs/cs35l41-lib.c b/sound/soc/codecs/cs35l41-lib.c
index 281a710a4123..8de5038ee9b3 100644
--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -422,7 +422,7 @@ static bool cs35l41_volatile_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static const struct cs35l41_otp_packed_element_t otp_map_1[CS35L41_NUM_OTP_ELEM] = {
+static const struct cs35l41_otp_packed_element_t otp_map_1[] = {
 	/* addr         shift   size */
 	{ 0x00002030,	0,	4 }, /*TRIM_OSC_FREQ_TRIM*/
 	{ 0x00002030,	7,	1 }, /*TRIM_OSC_TRIM_DONE*/
@@ -525,7 +525,7 @@ static const struct cs35l41_otp_packed_element_t otp_map_1[CS35L41_NUM_OTP_ELEM]
 	{ 0x00017044,	0,	24 }, /*LOT_NUMBER*/
 };
 
-static const struct cs35l41_otp_packed_element_t otp_map_2[CS35L41_NUM_OTP_ELEM] = {
+static const struct cs35l41_otp_packed_element_t otp_map_2[] = {
 	/* addr         shift   size */
 	{ 0x00002030,	0,	4 }, /*TRIM_OSC_FREQ_TRIM*/
 	{ 0x00002030,	7,	1 }, /*TRIM_OSC_TRIM_DONE*/
@@ -671,35 +671,35 @@ static const struct cs35l41_otp_map_element_t cs35l41_otp_map_map[] = {
 	{
 		.id = 0x01,
 		.map = otp_map_1,
-		.num_elements = CS35L41_NUM_OTP_ELEM,
+		.num_elements = ARRAY_SIZE(otp_map_1),
 		.bit_offset = 16,
 		.word_offset = 2,
 	},
 	{
 		.id = 0x02,
 		.map = otp_map_2,
-		.num_elements = CS35L41_NUM_OTP_ELEM,
+		.num_elements = ARRAY_SIZE(otp_map_2),
 		.bit_offset = 16,
 		.word_offset = 2,
 	},
 	{
 		.id = 0x03,
 		.map = otp_map_2,
-		.num_elements = CS35L41_NUM_OTP_ELEM,
+		.num_elements = ARRAY_SIZE(otp_map_2),
 		.bit_offset = 16,
 		.word_offset = 2,
 	},
 	{
 		.id = 0x06,
 		.map = otp_map_2,
-		.num_elements = CS35L41_NUM_OTP_ELEM,
+		.num_elements = ARRAY_SIZE(otp_map_2),
 		.bit_offset = 16,
 		.word_offset = 2,
 	},
 	{
 		.id = 0x08,
 		.map = otp_map_1,
-		.num_elements = CS35L41_NUM_OTP_ELEM,
+		.num_elements = ARRAY_SIZE(otp_map_1),
 		.bit_offset = 16,
 		.word_offset = 2,
 	},
-- 
2.35.1



