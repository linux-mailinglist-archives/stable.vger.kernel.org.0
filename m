Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525C5615992
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiKBDO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiKBDNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88744248EC
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A91617BA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2269AC433D6;
        Wed,  2 Nov 2022 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358798;
        bh=UoxeE9HNPV4TzxlU0hXWH4IHWBf0WxLfmRLAPSf9lsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUVcamIF+8gibMnWUCQegsThSqIgb79i2PGkmCUYZBvMMPKQaMbUgWLQcjeKVhf9y
         Ri8oLiOcaCg40iPcmqdoxm5w/jvry3bLw8sNh+oe1tCbW2oH6IoyPDlSRI3a4/SYdr
         1hSdtwqUop21YQd+e0/44lAwP+5LxbMiDNbAA8nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kamel Bouhara <kamel.bouhara@bootlin.com>,
        William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 5.10 27/91] counter: microchip-tcb-capture: Handle Signal1 read and Synapse
Date:   Wed,  2 Nov 2022 03:33:10 +0100
Message-Id: <20221102022055.816787603@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

commit d917a62af81b133f35f627e7936e193c842a7947 upstream.

The signal_read(), action_read(), and action_write() callbacks have been
assuming Signal0 is requested without checking. This results in requests
for Signal1 returning data for Signal0. This patch fixes these
oversights by properly checking for the Signal's id in the respective
callbacks and handling accordingly based on the particular Signal
requested. The trig_inverted member of the mchp_tc_data is removed as
superfluous.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Cc: stable@vger.kernel.org
Reviewed-by: Kamel Bouhara <kamel.bouhara@bootlin.com>
Link: https://lore.kernel.org/r/20221018121014.7368-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/microchip-tcb-capture.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -29,7 +29,6 @@ struct mchp_tc_data {
 	int qdec_mode;
 	int num_channels;
 	int channel[2];
-	bool trig_inverted;
 };
 
 enum mchp_tc_count_function {
@@ -163,7 +162,7 @@ static int mchp_tc_count_signal_read(str
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], SR), &sr);
 
-	if (priv->trig_inverted)
+	if (signal->id == 1)
 		sigstatus = (sr & ATMEL_TC_MTIOB);
 	else
 		sigstatus = (sr & ATMEL_TC_MTIOA);
@@ -181,6 +180,17 @@ static int mchp_tc_count_action_get(stru
 	struct mchp_tc_data *const priv = counter->priv;
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
@@ -209,8 +219,8 @@ static int mchp_tc_count_action_set(stru
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
 
-	/* QDEC mode is rising edge only */
-	if (priv->qdec_mode)
+	/* QDEC mode is rising edge only; only TIOA handled in non-QDEC mode */
+	if (priv->qdec_mode || synapse->signal->id != 0)
 		return -EINVAL;
 
 	switch (action) {


