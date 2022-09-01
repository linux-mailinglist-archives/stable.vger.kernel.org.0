Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C905A96D6
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiIAM3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiIAM3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:25 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEE112CB0B
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:31 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bq23so24180138lfb.7
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=k4NBR6s9gWn7dVHGD+znnsmpwT2y4F68Ss9fdXBxSN0=;
        b=JXbvSYm6hW7OclPyOCC6Lvv74gd97mzKXVEIVnr7I8fbeT3u23yVe9exIUvfPaSY34
         dbrJb80O2ZT1KJ5Z+akKS6ID9MqLkYMzUCFDYkPHy8q7CDPE6TOYvwVaKFxJJR1xIHug
         MWOjeHLp20jtq8q4JswdZVye9+jD7w0rpRM+tW9e5g9s/hT02F+VbfCckZPi/k5QgF6o
         7ws+EfQYkJ1ydvpzr4OL0kOJXjB8n8koRIjrmqG4cGfpb5fq9Xud8AVVbyUEoKnTPGkK
         l1KDMAzCtAFMq9K8pQNxHif/+qOrZtubQ9vm+3ke/1kACjmfGwXfcyz3w/KMhHdsn9IE
         oFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=k4NBR6s9gWn7dVHGD+znnsmpwT2y4F68Ss9fdXBxSN0=;
        b=iM0+FhaEHQrAP0GaQyg/G9yMnVw4t3Pmsr9YFXm20EjIljxJt0kmAEc2qvoQvSqCF4
         OQZSOfWsvdJPEoIaZtgUSZOiomvXVTngt0yO3NtyfrXa+jhI+3Rv74HjcSskuYFQh8fo
         xGbwOZTlA2XRNy2FzhCNl3mcRN+Hst2vE4slQp3s1Ja6ceSw2Zqn9mPij1DYE54cAKXF
         F3io9u5QiU750Aelsrl7aMBdvvjk2sml8xPs1+Xa7fLnOms2JzeWIyrCQlzhNLET4xBY
         XY15bvS1koEClZrzazkwMTHs4w3Ii5ORrSYHnEnheN4yESxYlmi87oYx2R2X0iwaK67Y
         tZPw==
X-Gm-Message-State: ACgBeo2mqXdJ1g0ge2bXOjyNU1c549+wWzeZoz5hjM2n95V9cXPCuxm6
        GsoVa45h0zzXIDPtpojZSIYALQ==
X-Google-Smtp-Source: AA6agR6spPoMcyADvCfHmkwpyymiB0LdSx2oKeqwb9peYsAI3Jf38KXKiXzVqZkqqg+79VaMU7sxPw==
X-Received: by 2002:a05:6512:3b2a:b0:494:72a8:bbeb with SMTP id f42-20020a0565123b2a00b0049472a8bbebmr5553381lfv.372.1662035308062;
        Thu, 01 Sep 2022 05:28:28 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:27 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 09/15] can: kvaser_usb_leaf: Fix CAN state after restart
Date:   Thu,  1 Sep 2022 14:27:23 +0200
Message-Id: <20220901122729.271-10-extja@kvaser.com>
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

can_restart() expects CMD_START_CHIP to set the error state to
ERROR_ACTIVE as it calls netif_carrier_on() immediately afterwards.

Otherwise the user may immediately trigger restart again and hit a
BUG_ON() in can_restart().

Fix kvaser_usb_leaf set_mode(CMD_START_CHIP) to set the expected state.

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

 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 48b8a0f0b362..a6a26085bc15 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1668,6 +1668,8 @@ static int kvaser_usb_leaf_set_mode(struct net_device *netdev,
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;
+
+		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.37.3

