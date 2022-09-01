Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4205A96D0
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiIAM3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiIAM3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:14 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC57134D48
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:24 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id q16so17701475ljp.8
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=JEoN1tJznbwSLj5X41YbOg96ajBu/6l48HoDPAWt4/w=;
        b=C6R372tgA6Wj77P2zG4Y37vXDYL0ee8K4vn5AsUdLoP7hL+mnJOt7/L9rQ9lG2AVlf
         ejjwMo535/o/Hui+j6KY54yWxHqk0rwT/wj/ctXClDvbiBWal+K4MP1YAxFY7L8L181Y
         Lt7bZNtunTqAZYSNpezUUDid2Wgk5mp51geBf0WaVvG/oCNAlIkRqrTnd2nIJga/pP0i
         yVHmWTDYZepBhdqCmgaNMWdN9/QXPi3CiuHc5zcFCBJhT9hHD9tX6ima1+ulZjxnaU1R
         3P6tJjLlYtAAbH9UnhsxaWmGW+/e/h6HGEL4ejz3FhUWzO4uNqcxCGEV4/uEi7WGZJWR
         RgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=JEoN1tJznbwSLj5X41YbOg96ajBu/6l48HoDPAWt4/w=;
        b=iM2j9uoztIYp+XB1yMy8OUTLmfEorH/qw265DJ80CZxonErepupVk6Pi6skXEIDz/l
         DuEx7VlbMNMd9CMmsnxxRxo02RJidBejj8L1U1rxXyum+aRPcszLB9BsE/F2k7xBw2sm
         zAm93uxs+ozIx11VszXCkapqlmN+teSVrB9RT8zuVCQS6EQvWVLNXG7I7nyKq5thwiS6
         onziZp9U9dPnc4tP37TxeR+84cURAei53lrsGvsTvjKJghf51msMIusOPWml5/hGXE46
         SNOBMAV4kHx3OFcXSF7Iy3QyoriwejLM1O87HLqI/r0oaSVYoAtfDG8+CGhoDrJM2n55
         r4TQ==
X-Gm-Message-State: ACgBeo28FAFIyBoG9E0B/bS3IR1o6767/RmPb/J+CNtUkEXTqOfq5bJ4
        L9+5GtDKHP00SAFa3HeR0rUMRA==
X-Google-Smtp-Source: AA6agR6fj9Yh7LIBSdgZI6I0amXZLrjrQfpw6OHgz3sCuQZZHghBYzUbuhVF9YY3JsBvWWq1a6nQHw==
X-Received: by 2002:a2e:b5a2:0:b0:263:3745:a554 with SMTP id f2-20020a2eb5a2000000b002633745a554mr7075086ljn.190.1662035302336;
        Thu, 01 Sep 2022 05:28:22 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:21 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 02/15] can: kvaser_usb: Fix use of uninitialized completion
Date:   Thu,  1 Sep 2022 14:27:16 +0200
Message-Id: <20220901122729.271-3-extja@kvaser.com>
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

flush_comp is initialized when CMD_FLUSH_QUEUE is sent to the device and
completed when the device sends CMD_FLUSH_QUEUE_RESP.

This causes completion of uninitialized completion if the device sends
CMD_FLUSH_QUEUE_RESP before CMD_FLUSH_QUEUE is ever sent (e.g. as a
response to a flush by a previously bound driver, or a misbehaving
device).

Fix that by initializing flush_comp in kvaser_usb_init_one() like the
other completions.

This issue is only triggerable after RX URBs have been set up, i.e. the
interface has been opened at least once.

Cc: stable@vger.kernel.org
Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
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

 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  | 1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 824cab80aa02..c2bce6773adc 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -729,6 +729,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 	init_usb_anchor(&priv->tx_submitted);
 	init_completion(&priv->start_comp);
 	init_completion(&priv->stop_comp);
+	init_completion(&priv->flush_comp);
 	priv->can.ctrlmode_supported = 0;
 
 	priv->dev = dev;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index dd65c101bfb8..3dcd35979e6f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1916,7 +1916,7 @@ static int kvaser_usb_hydra_flush_queue(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->flush_comp);
+	reinit_completion(&priv->flush_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_FLUSH_QUEUE,
 					       priv->channel);
-- 
2.37.3

