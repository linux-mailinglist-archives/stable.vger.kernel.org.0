Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005D75AC0A4
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiICSZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiICSZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:40 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7681089
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:38 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id p16so7687555lfd.6
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=uLXJ7T8bIUy0M4UDvprkLfnfxxyvIBpgMPGkOs0v/0U=;
        b=iS6BRI1xfr8GZGXURGZILJqg2tJA2YYW7pp7vggRv5pR+gwVv9rf04D+MMalv9qHkU
         ZUhme0y+hMsXZ87Zy0fUaC3qeAlY8F6tamW82E0hMUG7AQqsGjmmJerBfrwx1kgaaR4t
         frqDZj4kgez/WGw7mRC1GCiREPyYQKPV7/92GjdF+ihAuMQK4cpzdM2eBR1LkjNsT79v
         ml44PmErfYXcZo628EBrGtLrz1zWUBXauTcyLeArc0MI3J9vQJRJ7kvzGwDG9ypVX8/p
         ql9Lmxkyq18Lfc8uU1vBcgoK71/gWN9j/RoHksAj9Ed/5gumhGHBsOJI4UwC3+MlmWvE
         LfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uLXJ7T8bIUy0M4UDvprkLfnfxxyvIBpgMPGkOs0v/0U=;
        b=Hplrtz0hh2lEM9qtUQI+NM7/d0kyNhljR7YJd5IEQE3o7gGAfF9ibUkc2kCbaIl4k3
         qqLFNgwwnnN02F/M1C2N5MEnTQSStykwLIrU49cTjfL6x4O740pXyntDXLSNd33+H9xY
         qbn6GJ083Jzqwl+Fi6ztWu8G0MiP45ArNRdH3o62hixx/zvgqxdFUDfyWabMkZ0uOdu8
         ohUD7liB16wD8D6psYrierFz1/rSzuBOxhV0Zha7MPj4uh/4aNDkpFJijCL2DBbLwarl
         N/On9dlJhtDdjqf80/hzn4ncW/gOQ0BFsgSGo0bwo+48sRdf8NtojFpysnzmf0YbjxGK
         jIMg==
X-Gm-Message-State: ACgBeo3sIm2L/xLwsDme7m20EJ7ceDRnPGsLAmRNNO/f1nIQnja/0ATP
        /1B4OVZ2HnhJO3haK1ukmjaEDg==
X-Google-Smtp-Source: AA6agR6Hu3HWUB+aVquvag3KvGVz7PEMlFt366we2ad1nN8fQCiMyjdHAGmt3ARBqa9a9VRKl6D8Qg==
X-Received: by 2002:a05:6512:1149:b0:494:9b4f:75e5 with SMTP id m9-20020a056512114900b004949b4f75e5mr4713376lfg.236.1662229536936;
        Sat, 03 Sep 2022 11:25:36 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:36 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 03/15] can: kvaser_usb: Fix possible completions during init_completion
Date:   Sat,  3 Sep 2022 20:25:47 +0200
Message-Id: <20220903182559.189-3-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220903182559.189-1-extja@kvaser.com>
References: <20220903182559.189-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

kvaser_usb uses completions to signal when a response event is received
for outgoing commands.

However, it uses init_completion() to reinitialize the start_comp and
stop_comp completions before sending the start/stop commands.

In case the device sends the corresponding response just before the
actual command is sent, complete() may be called concurrently with
init_completion() which is not safe.

This might be triggerable even with a properly functioning device by
stopping the interface (CMD_STOP_CHIP) just after it goes bus-off (which
also causes the driver to send CMD_STOP_CHIP when restart-ms is off),
but that was not tested.

Fix the issue by using reinit_completion() instead.

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

 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3dcd35979e6f..3abfaa77e893 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1875,7 +1875,7 @@ static int kvaser_usb_hydra_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_START_CHIP_REQ,
 					       priv->channel);
@@ -1893,7 +1893,7 @@ static int kvaser_usb_hydra_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	/* Make sure we do not report invalid BUS_OFF from CMD_CHIP_STATE_EVENT
 	 * see comment in kvaser_usb_hydra_update_state()
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 8e11cda85624..9683bc5e8257 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1320,7 +1320,7 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
 					      priv->channel);
@@ -1338,7 +1338,7 @@ static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);
-- 
2.37.3

