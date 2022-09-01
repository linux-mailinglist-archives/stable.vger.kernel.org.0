Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967765A96D2
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiIAM3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiIAM3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:18 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73C12BF46
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:29 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bq23so24180006lfb.7
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4SyDa9UEsa0CVkPsO+GsaQLA888zZ/gHrKd/Ws+KQbU=;
        b=eRZOCbKycHuGTIvxuFjcXEgCp5FNgSUH0IvFppIiA20Kk7j6UEq3mqOg0oFf0jZDIq
         9KwF0rKr1+dnSAmUZI4Zg4COwu2gr5av5AVeTvC7d78lXgI7i2SgHckKYthP1C434WN+
         O+O9l9813ju/QGncVIc96vc6T1yl+asAamVIrrt8pEd9nE/2cG1st51m67IYfTrWyLbu
         e/xCyaeNtrasxnkGz1V2eg6FQDiNhvZfFsd4RJnX0320h72OMVSktcbJlM7+7yor7Cf1
         +F4lhwovLUo8DrZn7PgjMpANQE3nYq6TCfk2CaWzl4A0LFmvFCBO+crbrdGAHM/aVt4I
         fXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4SyDa9UEsa0CVkPsO+GsaQLA888zZ/gHrKd/Ws+KQbU=;
        b=guJwde4PfMxm1JChx5nRUdza4Mhm091vEz63wd41twdXJ6uvBFgNBbSNSK3Fzo55NV
         tg9daDwDo1uI1XTunPk8B43MvjD19ZNs11TmV6Iw3gi/3xx8D9/ybxWF0whrQaT/fD3j
         pT0BtCIlxB6RK+guZ8Os6xOF89WLKwo6cnaCAS8OMCNTLTw+l0Wu3bVvDVBvSzIZ5ls9
         4/fHdHE18435KoRZbj0gCL4gXny4Ry6CGQnW9pmxsAcZ+y02OZaFU8k5OEl3Joy5lVvz
         mZS1/UzC7TP3IvnivdWH6ReBoxgu2LX903tbr+g1lo4oF1R9i57ylZQHT8S5ofDBg0Uf
         0D2w==
X-Gm-Message-State: ACgBeo2vRHxE9rHHEIPfkHwnbs57ZyuFdQBipZyCFDvuljRGYFkfw8fG
        9+jXQcWPGMQkys7X9fyWB3IIpw==
X-Google-Smtp-Source: AA6agR6CdSA1FBrGY0NvzrjMmyL+WsrEA+L4S46dcTFqjxbchTsrUPQhwXhv92T6bkfoxMgHWXCxoA==
X-Received: by 2002:a05:6512:3fa9:b0:492:d799:1038 with SMTP id x41-20020a0565123fa900b00492d7991038mr10761468lfa.574.1662035306475;
        Thu, 01 Sep 2022 05:28:26 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:26 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 07/15] can: kvaser_usb_leaf: Set Warning state even without bus errors
Date:   Thu,  1 Sep 2022 14:27:21 +0200
Message-Id: <20220901122729.271-8-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220901122729.271-1-extja@kvaser.com>
References: <20220901122729.271-1-extja@kvaser.com>
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

