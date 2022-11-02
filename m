Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C91615979
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKBDM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiKBDMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071FB2408E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D012616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46376C433C1;
        Wed,  2 Nov 2022 03:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358696;
        bh=pqSnykMIfQxwmzSq2JcY8DwL0vLvZnQpAXlCjQHnWo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQGr6HTku2UFCEqUI+Gc/mo5N+YizXfzu03xlhGBxX00yP51N5uEYukzYjJ+75xr9
         Q36QBTJqDlb1VnJCyCRJhU1U+9WdsngfxeVNharu0CYQoSYWCjSI87LPgapdXwXN36
         OlNhyVv9z/qkKPDXIZb7yXjTOneDCWZKxy1+t9d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 02/91] can: kvaser_usb: Fix possible completions during init_completion
Date:   Wed,  2 Nov 2022 03:32:45 +0100
Message-Id: <20221102022055.112724353@linuxfoundation.org>
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 2871edb32f4622c3a25ce4b3977bad9050b91974 upstream.

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

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-2-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1845,7 +1845,7 @@ static int kvaser_usb_hydra_start_chip(s
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_START_CHIP_REQ,
 					       priv->channel);
@@ -1863,7 +1863,7 @@ static int kvaser_usb_hydra_stop_chip(st
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	/* Make sure we do not report invalid BUS_OFF from CMD_CHIP_STATE_EVENT
 	 * see comment in kvaser_usb_hydra_update_state()
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1324,7 +1324,7 @@ static int kvaser_usb_leaf_start_chip(st
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
 					      priv->channel);
@@ -1342,7 +1342,7 @@ static int kvaser_usb_leaf_stop_chip(str
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);


