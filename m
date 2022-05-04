Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6861A51AA34
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347444AbiEDRWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357378AbiEDRPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A164C786;
        Wed,  4 May 2022 09:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6C26190E;
        Wed,  4 May 2022 16:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504BFC385AA;
        Wed,  4 May 2022 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683500;
        bh=Yin+YIOwRDSLjxFgNOB0DFj+qPCPFVJCMRkOd+EWZdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DUE0qU6ryTTV3jkWrIfd+/IxRiJTZnTAdI58vah/s2fC7IdEEMJIWhE/4iJHg1kT
         UhVmzb3ae+SvDBWa0nsG1fpzY25xyem8HXSgNurDycqjQXYccZV/pVXB5da70Nk2Mg
         StZ3Uj25SYXT2PTFWojmze7bSZUemQswzWJwHyV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 158/225] ASoC: cs35l41: Fix a shift-out-of-bounds warning found by UBSAN
Date:   Wed,  4 May 2022 18:46:36 +0200
Message-Id: <20220504153124.131187127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 0b3d5d2e358ca6772fc3662fca27acb12a682fbf ]

We enabled UBSAN in the ubuntu kernel, and the cs35l41 driver triggers
a warning calltrace like below:

cs35l41-hda i2c-CSC3551:00-cs35l41-hda.0: bitoffset= 8, word_offset=23, bit_sum mod 32=0, otp_map[i].size = 24
cs35l41-hda i2c-CSC3551:00-cs35l41-hda.0: bitoffset= 0, word_offset=24, bit_sum mod 32=24, otp_map[i].size = 0
================================================================================
UBSAN: shift-out-of-bounds in linux-kernel-src/sound/soc/codecs/cs35l41-lib.c:836:8
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

When both bitoffset and otp_map[i].size are 0, the line 836 will
result in GENMASK(-1, 0), this triggers the shift-out-of-bounds
calltrace.

Here add a checking, if both bitoffset and otp_map[i].size are 0,
do not run GENMASK() and directly set otp_val to 0, this will not
bring any function change on the driver but could avoid the calltrace.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20220324081839.62009-2-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l41-lib.c b/sound/soc/codecs/cs35l41-lib.c
index e5a56bcbb223..281a710a4123 100644
--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -831,12 +831,14 @@ int cs35l41_otp_unpack(struct device *dev, struct regmap *regmap)
 					GENMASK(bit_offset + otp_map[i].size - 33, 0)) <<
 					(32 - bit_offset);
 			bit_offset += otp_map[i].size - 32;
-		} else {
+		} else if (bit_offset + otp_map[i].size - 1 >= 0) {
 			otp_val = (otp_mem[word_offset] &
 				   GENMASK(bit_offset + otp_map[i].size - 1, bit_offset)
 				  ) >> bit_offset;
 			bit_offset += otp_map[i].size;
-		}
+		} else /* both bit_offset and otp_map[i].size are 0 */
+			otp_val = 0;
+
 		bit_sum += otp_map[i].size;
 
 		if (bit_offset == 32) {
-- 
2.35.1



