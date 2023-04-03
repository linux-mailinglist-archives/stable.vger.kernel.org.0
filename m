Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9226D4940
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjDCOgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbjDCOgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:36:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD7116F31
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B637CE12E2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692CCC433EF;
        Mon,  3 Apr 2023 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532565;
        bh=8uAfPanuz/OzQylChCvYETt3kEKVswS+MP8NmyFmloQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sa2QKb3hC41pzYNQYxziYzt0fzZaeMiN+asSsW609w3FMfYDJztS1QJKLVSj9gFuW
         iyv++x4WrAJWnnjcbMxC9Ou8N8PL53AfmuXPGPMZ9sovPiJM6x94n+xiD02xTwrWFS
         VfpNudVl0f7KxBtcEUj8qMTbb6XF//XDzL6AEBy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/181] ASoC: codecs: tx-macro: Fix for KASAN: slab-out-of-bounds
Date:   Mon,  3 Apr 2023 16:07:47 +0200
Message-Id: <20230403140416.208969912@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com>

[ Upstream commit e5e7e398f6bb7918dab0612eb6991f7bae95520d ]

When we run syzkaller we get below Out of Bound.
    "KASAN: slab-out-of-bounds Read in regcache_flat_read"

    Below is the backtrace of the issue:

    dump_backtrace+0x0/0x4c8
    show_stack+0x34/0x44
    dump_stack_lvl+0xd8/0x118
    print_address_description+0x30/0x2d8
    kasan_report+0x158/0x198
    __asan_report_load4_noabort+0x44/0x50
    regcache_flat_read+0x10c/0x110
    regcache_read+0xf4/0x180
    _regmap_read+0xc4/0x278
    _regmap_update_bits+0x130/0x290
    regmap_update_bits_base+0xc0/0x15c
    snd_soc_component_update_bits+0xa8/0x22c
    snd_soc_component_write_field+0x68/0xd4
    tx_macro_digital_mute+0xec/0x140

    Actually There is no need to have decimator with 32 bits.
    By limiting the variable with short type u8 issue is resolved.

Signed-off-by: Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com>
Link: https://lore.kernel.org/r/20230304080702.609-1-quic_visr@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 5d1c58df081ac..e5611f655beda 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -241,7 +241,7 @@ enum {
 
 struct tx_mute_work {
 	struct tx_macro *tx;
-	u32 decimator;
+	u8 decimator;
 	struct delayed_work dwork;
 };
 
@@ -634,7 +634,7 @@ static int tx_macro_mclk_enable(struct tx_macro *tx,
 	return 0;
 }
 
-static bool is_amic_enabled(struct snd_soc_component *component, int decimator)
+static bool is_amic_enabled(struct snd_soc_component *component, u8 decimator)
 {
 	u16 adc_mux_reg, adc_reg, adc_n;
 
@@ -845,7 +845,7 @@ static int tx_macro_enable_dec(struct snd_soc_dapm_widget *w,
 			       struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
-	unsigned int decimator;
+	u8 decimator;
 	u16 tx_vol_ctl_reg, dec_cfg_reg, hpf_gate_reg, tx_gain_ctl_reg;
 	u8 hpf_cut_off_freq;
 	int hpf_delay = TX_MACRO_DMIC_HPF_DELAY_MS;
@@ -1060,7 +1060,8 @@ static int tx_macro_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_soc_dai *dai)
 {
 	struct snd_soc_component *component = dai->component;
-	u32 decimator, sample_rate;
+	u32 sample_rate;
+	u8 decimator;
 	int tx_fs_rate;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
 
@@ -1124,7 +1125,7 @@ static int tx_macro_digital_mute(struct snd_soc_dai *dai, int mute, int stream)
 {
 	struct snd_soc_component *component = dai->component;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
-	u16 decimator;
+	u8 decimator;
 
 	/* active decimator not set yet */
 	if (tx->active_decimator[dai->id] == -1)
-- 
2.39.2



