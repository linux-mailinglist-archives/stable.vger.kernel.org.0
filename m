Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2973441F6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCVMhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhCVMgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B180E619A4;
        Mon, 22 Mar 2021 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416549;
        bh=mA6n9q3KDXJcFo/kEYdcN1dVGe5Dx/XAbgn+TiqxXgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oOOnKVRaSPzyM0oCDERieQ2f1GJngh13lCBUWTNZtdMTWBgiedXiDC6rg13ZfxAy
         IzZ5cmw2zOTrKF7mk4qpY0fiJcZNTMNSN2/trYgPRapVR63MWUvUPBQzbuRHsFjQoQ
         NVGBpDlimY1iT4XlVgyigqM7lV1BcQdz3ntbXzaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 028/157] ASoC: qcom: sdm845: Fix array out of bounds access
Date:   Mon, 22 Mar 2021 13:26:25 +0100
Message-Id: <20210322121934.657333988@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 1c668e1c0a0f74472469cd514f40c9012b324c31 upstream.

Static analysis Coverity had detected a potential array out-of-bounds
write issue due to the fact that MAX AFE port Id was set to 16 instead
of using AFE_PORT_MAX macro.

Fix this by properly using AFE_PORT_MAX macro.

Fixes: 1b93a8843147 ("ASoC: qcom: sdm845: handle soundwire stream")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210309142129.14182-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/sdm845.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -33,12 +33,12 @@
 struct sdm845_snd_data {
 	struct snd_soc_jack jack;
 	bool jack_setup;
-	bool stream_prepared[SLIM_MAX_RX_PORTS];
+	bool stream_prepared[AFE_PORT_MAX];
 	struct snd_soc_card *card;
 	uint32_t pri_mi2s_clk_count;
 	uint32_t sec_mi2s_clk_count;
 	uint32_t quat_tdm_clk_count;
-	struct sdw_stream_runtime *sruntime[SLIM_MAX_RX_PORTS];
+	struct sdw_stream_runtime *sruntime[AFE_PORT_MAX];
 };
 
 static unsigned int tdm_slot_offset[8] = {0, 4, 8, 12, 16, 20, 24, 28};


