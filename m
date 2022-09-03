Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EA45AC0A8
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiICSZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbiICSZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37F542AE8
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:45 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z6so7657682lfu.9
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=23b25x3aGOj9dhZsjRbrRAZULH2okk23PQBbMXv4TQo=;
        b=vQYxNjjIszvd/+YPPpcKOS3kpjA7o4889HcE+un97VteUO+Ig7fG+65RhX6vRNjwkY
         ndBRh23Dqn7nHGYfvfH3jaKQA4q86lCj6W8GEg0kAoT351iJ4h0NBfkpaex3V2r9uB9x
         PyNIfG5d8cj0/kbrb5TbVn8BLArfFXHRr2FO4VtxsH5+RVY/qxBOJ6QXf30xup0rEA8D
         KbdfB7AOchs9TiLg7xpTJhinkrNxueWAIwxumoKOZ1O7hH4oNu0uY0NggSxRkQNKm4pk
         MchMBRa9+ztQCHhKjjgwrTJ1iXx0EXeLcj8t5JG2TmIkzNYqDfP2oJU9di+4YzofhflS
         W2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=23b25x3aGOj9dhZsjRbrRAZULH2okk23PQBbMXv4TQo=;
        b=SH7QcXV1GpeCaxT207HWZwupLchPV8DSq71o7KpxfmJD0AJWVAwrh7DGnlOvKN6WCS
         /qKLg9+sPiDysTv+yfELSnXVa2E815aFXqrw7+uaxjcoy09/60iO1pHzUa+Wc+xqoBAi
         wZJ8uB891y9oUOc/SnzhbCkyCbSN2HpRvzz4c8OODRQ7ZQoEOkylBYwgcysnICaXI/iv
         NE97I91QLGP9UsBcrkvHWrV7Mz2ogPUqzAJgYtHxchW353SdBcRNh+tSrdyymHZx5WPU
         qyfwbYiBY/94Ea1ZRam6mPqFyxSJrVRRG8DPal/kINsTK4jXr/bEe3Yf6cdgFxNLnfAd
         HJJg==
X-Gm-Message-State: ACgBeo0FVY1XNrt69+q7jF/20sR6nyCumuaeKPBvbJE7N6qVTX8lRzUG
        I3gNh7PVA1CKKC5ngN12IuwGtQ==
X-Google-Smtp-Source: AA6agR7Hy/nJQvUmHvtIdrQv1P1JmvJ1HbUtj8KMaSnBQNUAMVQq7aQpyLgXs6D5Opf33WoGz/y5qg==
X-Received: by 2002:a19:670b:0:b0:48b:a108:e707 with SMTP id b11-20020a19670b000000b0048ba108e707mr14515039lfc.474.1662229544026;
        Sat, 03 Sep 2022 11:25:44 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:43 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 07/15] can: kvaser_usb_leaf: Set Warning state even without bus errors
Date:   Sat,  3 Sep 2022 20:25:51 +0200
Message-Id: <20220903182559.189-7-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220903182559.189-1-extja@kvaser.com>
References: <20220903182559.189-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

kvaser_usb_leaf_rx_error_update_can_state() sets error state according
to error counters when the hardware does not indicate a specific state
directly.

However, this is currently gated behind a check for
M16C_STATE_BUS_ERROR which does not always seem to be set when error
counters are increasing, and may not be set when error counters are
decreasing.

This causes the CAN_STATE_ERROR_WARNING state to not be set in some
cases even when appropriate.

Change the code to set error state from counters even without
M16C_STATE_BUS_ERROR.

The Error-Passive case seems superfluous as it is already set via
M16C_STATE_BUS_PASSIVE flag above, but it is kept for now.

Tested with 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v4:
 - No changes

Changes in v3:
 - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add stable to CC
 - Add S-o-b

Changes in v2:
  - Rebased on b3b6df2c56d8 ("can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits")

 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index cd5b67f48534..b4acd9427967 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -961,20 +961,16 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 		new_state = CAN_STATE_BUS_OFF;
 	} else if (es->status & M16C_STATE_BUS_PASSIVE) {
 		new_state = CAN_STATE_ERROR_PASSIVE;
-	} else if (es->status & M16C_STATE_BUS_ERROR) {
+	} else if ((es->status & M16C_STATE_BUS_ERROR) &&
+		   cur_state >= CAN_STATE_BUS_OFF) {
 		/* Guard against spurious error events after a busoff */
-		if (cur_state < CAN_STATE_BUS_OFF) {
-			if (es->txerr >= 128 || es->rxerr >= 128)
-				new_state = CAN_STATE_ERROR_PASSIVE;
-			else if (es->txerr >= 96 || es->rxerr >= 96)
-				new_state = CAN_STATE_ERROR_WARNING;
-			else if (cur_state > CAN_STATE_ERROR_ACTIVE)
-				new_state = CAN_STATE_ERROR_ACTIVE;
-		}
-	}
-
-	if (!es->status)
+	} else if (es->txerr >= 128 || es->rxerr >= 128) {
+		new_state = CAN_STATE_ERROR_PASSIVE;
+	} else if (es->txerr >= 96 || es->rxerr >= 96) {
+		new_state = CAN_STATE_ERROR_WARNING;
+	} else {
 		new_state = CAN_STATE_ERROR_ACTIVE;
+	}
 
 	if (new_state != cur_state) {
 		tx_state = (es->txerr >= es->rxerr) ? new_state : 0;
-- 
2.37.3

