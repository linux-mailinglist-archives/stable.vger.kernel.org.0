Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E910601CA9
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiJQWyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 18:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJQWyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 18:54:31 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB62F031
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 15:54:28 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id m6so7659310qkm.4
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 15:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Mexi3DbJyE5x8I4sskOGI0Kl0weNbMfBZ28HFha2I=;
        b=G+VVV/nIqdIuzoizvBtuqpU6jTPkoDxoOhBUBWkyNMOzp5olRCaTXnLJUNSlWR537c
         2I/usnZFVwwfouojQyDH+/oIgDZOWsxLYYtS2S+Hj6IZvy4P15FHwcCI1W1pKHhlG84B
         dle0W1Bu3IhXVK8OKNuqRfZwRnouM8gywQ701XDxRO/uKkFI/cPBHvH1/CPQ5M+g4Sn9
         XxuHI1KSYD7NjEg/73Uu38CZjzESsBapRNXIHBh/UIpuEVWMvMHzMbTvj15J6mruKVsR
         /mvPvVnr2y4Kj/6PhInorv3R2Nc7fp4XCBM/wvkYHiPJxEEsbMRWsL+37XcGC/zcwh2l
         QPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1Mexi3DbJyE5x8I4sskOGI0Kl0weNbMfBZ28HFha2I=;
        b=2wGUn8BTYyp8bsxAInnUgLjYJk4r1b2Pwk6sky0aPREXTot90fULzP1UvrXn1Ta3/f
         CUpFyniGvUaVPnoEnJr79qwCIrzXfcfP1OZqBbfj3dFuNLqSzVirx9ro+8/mdA4Cun5i
         ui9XBachiu81uVFe6xB8PVyn6o81k1twDJc98wsby1AvkS+dTn0125ZyvwmEWtGKv2gl
         W5WinR2OUggGCNgdhFO0/VZjRY4dwsIFYPoJ3v68NKFjs1IbCEAS6sCRo0MaJklrcW10
         SjOVeg20w2X5lniQxnoP6drULLYsZFubgmZkSRHxugcK0hv6cmx4z7PainVLKvji5QZs
         ehaQ==
X-Gm-Message-State: ACrzQf3VenYOY+D4nMRmznFhcbl5ljEug75iukVzm1340OswCZ7tbX4i
        1FJQP+4FQTH7N2sV6EP12CvB7w==
X-Google-Smtp-Source: AMsMyM4b+4PFpIn3M0+u/YSe6yeAsBDlE0Ai0sYBJFsY8y10pR6/dGF0fH1Ue8Hb5gDPLSxWv9ijqw==
X-Received: by 2002:a05:620a:a9c:b0:6ec:f03:9e5b with SMTP id v28-20020a05620a0a9c00b006ec0f039e5bmr9314606qkg.628.1666047267901;
        Mon, 17 Oct 2022 15:54:27 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id bv8-20020a05622a0a0800b0038b684a1642sm755675qtb.32.2022.10.17.15.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 15:54:27 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@kernel.org, Kamel Bouhara <kamel.bouhara@bootlin.com>
Subject: [PATCH] counter: microchip-tcb-capture: Handle Signal1 read and Synapse
Date:   Mon, 17 Oct 2022 18:54:04 -0400
Message-Id: <20221017225404.67127-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The signal_read(), action_read(), and action_write() callbacks have been
assuming Signal0 is requested without checking. This results in requests
for Signal1 returning data for Signal0. This patch fixes these
oversights by properly checking for the Signal's id in the respective
callbacks and handling accordingly based on the particular Signal
requested. The trig_inverted member of the mchp_tc_data is removed as
superfluous.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Cc: stable@kernel.org
Cc: Kamel Bouhara <kamel.bouhara@bootlin.com>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/microchip-tcb-capture.c | 57 ++++++++++++++++---------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index f9dee15d9777..438f82b07a03 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -28,7 +28,6 @@ struct mchp_tc_data {
 	int qdec_mode;
 	int num_channels;
 	int channel[2];
-	bool trig_inverted;
 };
 
 static const enum counter_function mchp_tc_count_functions[] = {
@@ -153,7 +152,7 @@ static int mchp_tc_count_signal_read(struct counter_device *counter,
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], SR), &sr);
 
-	if (priv->trig_inverted)
+	if (signal->id == 1)
 		sigstatus = (sr & ATMEL_TC_MTIOB);
 	else
 		sigstatus = (sr & ATMEL_TC_MTIOA);
@@ -169,26 +168,46 @@ static int mchp_tc_count_action_read(struct counter_device *counter,
 				     enum counter_synapse_action *action)
 {
 	struct mchp_tc_data *const priv = counter_priv(counter);
+	const unsigned int cmr_reg = ATMEL_TC_REG(priv->channel[0], CMR);
+	enum counter_function function;
+	int err;
 	u32 cmr;
 
-	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
+	err = mchp_tc_count_function_read(counter, count, &function);
+	if (err)
+		return err;
 
-	switch (cmr & ATMEL_TC_ETRGEDG) {
-	default:
-		*action = COUNTER_SYNAPSE_ACTION_NONE;
-		break;
-	case ATMEL_TC_ETRGEDG_RISING:
-		*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
-		break;
-	case ATMEL_TC_ETRGEDG_FALLING:
-		*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
-		break;
-	case ATMEL_TC_ETRGEDG_BOTH:
+	/* Default action mode */
+	*action = COUNTER_SYNAPSE_ACTION_NONE;
+
+	switch (function) {
+	case COUNTER_FUNCTION_INCREASE:
+		/* TIOB signal is ignored */
+		if (synapse->signal->id == 1)
+			return 0;
+
+		regmap_read(priv->regmap, cmr_reg, &cmr);
+
+		switch (cmr & ATMEL_TC_ETRGEDG) {
+		case ATMEL_TC_ETRGEDG_RISING:
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
+			return 0;
+		case ATMEL_TC_ETRGEDG_FALLING:
+			*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
+			return 0;
+		case ATMEL_TC_ETRGEDG_BOTH:
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+			return 0;
+		default:
+			return 0;
+		}
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
-		break;
+		return 0;
+	default:
+		/* should never reach this path */
+		return -EINVAL;
 	}
-
-	return 0;
 }
 
 static int mchp_tc_count_action_write(struct counter_device *counter,
@@ -199,8 +218,8 @@ static int mchp_tc_count_action_write(struct counter_device *counter,
 	struct mchp_tc_data *const priv = counter_priv(counter);
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
 
-	/* QDEC mode is rising edge only */
-	if (priv->qdec_mode)
+	/* QDEC mode is rising edge only; only TIOA handled in non-QDEC mode */
+	if (priv->qdec_mode || synapse->signal->id != 0)
 		return -EINVAL;
 
 	switch (action) {
-- 
2.37.3

