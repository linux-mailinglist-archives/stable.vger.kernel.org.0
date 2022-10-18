Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CAA602B50
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJRMK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 08:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJRMK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 08:10:26 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0711A02F2
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 05:10:23 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id a16-20020a056830101000b006619dba7fd4so7467591otp.12
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 05:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sqIGFF02dOX61CeJGtzYtpVGadQKDl0ST8ygfx0xxyk=;
        b=SE0h0V1PdBrlN7sPGSVPZed0BbibTZmQGB+yWcLc785hrDuhvlUzhKj5+LAeiwvmRp
         HXWIK5YLXREvy5NDpUkzl2oqzmwYa+Hjv3T/xKouaNbhIPMiTeUbqCr5lIp2CN+/Erx0
         ssNCjNoCJPT7jr+VzhNLw8PdMclJWqz5QXoN0mUtvNrqyuoZDaMvq5t++6YCsWjVZFYR
         hK7ogTULSBDYl/KpAI15dgzsDZzATWrFvZttQoX8c2z/k6SmDyqkD0hhHsiNarKFJzxf
         E70ehtCE1mImVUQdECpbYGbyDX2vPOYYtbE//W3e5S0DTwzrEgL/HNeF+wia6bdBmONK
         BFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sqIGFF02dOX61CeJGtzYtpVGadQKDl0ST8ygfx0xxyk=;
        b=GBysx/NiRPLLvGOb6pJzjKK4QkbtdhOxiYwDavcaihcXkmW6ZQDNEmLxuMEfila1dz
         SAbmLQGSEAVLCcpPrgZ/pmtgaeYDv6Gmg5cRxWzAd61UVgzeInTqYypPpfCh55jIJ6uz
         1LHQg4CpbpDt/6SET3ikAzrqWtGG0xXAIgacdVekUTgPdNUwg97LANxvhnqtg1BrMKFS
         VALdrUcDnXv/0EIL0emOw9PFIIryZVoaY77sU4jDlR7ht1pjGfC8TlyzDSp0a4BpYokD
         Pd/3F157xrJrFbFy8jJ/8hfqsDYH7H9SZ+/wmTCRi4bLUAPmGgPXgh8RDj8unWfN4MRI
         fRuQ==
X-Gm-Message-State: ACrzQf25Y0ySlF4qPgRj3TeC6OYulsgxa0VDOy0Wj+TreQONgWZ16P2n
        LbfitIFCZqdEJRBr+LULXbu2wA==
X-Google-Smtp-Source: AMsMyM6xWo57saFHMqU9gzS6cbmC8IN1slWlfsaCn1nv7yc+VWbgWZ9Sfp96e7jtBvtVFbXtOCfQxw==
X-Received: by 2002:a05:6830:b93:b0:660:eef5:76b6 with SMTP id a19-20020a0568300b9300b00660eef576b6mr1159698otv.18.1666095022396;
        Tue, 18 Oct 2022 05:10:22 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id x8-20020a056830408800b0065c2c46077dsm5737102ott.67.2022.10.18.05.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 05:10:21 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org,
        William Breathitt Gray <william.gray@linaro.org>,
        Kamel Bouhara <kamel.bouhara@bootlin.com>
Subject: [PATCH v2] counter: microchip-tcb-capture: Handle Signal1 read and Synapse
Date:   Tue, 18 Oct 2022 08:10:14 -0400
Message-Id: <20221018121014.7368-1-william.gray@linaro.org>
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
Cc: stable@vger.kernel.org
Cc: Kamel Bouhara <kamel.bouhara@bootlin.com>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
Changes in v2:
 - Simplified action_read() changes to just handle qdec_mode and
   non-TIOA Signals before continuing with existing code

 drivers/counter/microchip-tcb-capture.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index f9dee15d9777..e2d1dc6ca668 100644
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
@@ -171,6 +170,17 @@ static int mchp_tc_count_action_read(struct counter_device *counter,
 	struct mchp_tc_data *const priv = counter_priv(counter);
 	u32 cmr;
 
+	if (priv->qdec_mode) {
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+		return 0;
+	}
+
+	/* Only TIOA signal is evaluated in non-QDEC mode */
+	if (synapse->signal->id != 0) {
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
+		return 0;
+	}
+
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
 
 	switch (cmr & ATMEL_TC_ETRGEDG) {
@@ -199,8 +209,8 @@ static int mchp_tc_count_action_write(struct counter_device *counter,
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

