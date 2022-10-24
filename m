Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E1560B819
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiJXTlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiJXTlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:41:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DDEDD895;
        Mon, 24 Oct 2022 11:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD739B811CC;
        Mon, 24 Oct 2022 11:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323A3C433D7;
        Mon, 24 Oct 2022 11:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612587;
        bh=tuRrGyRDE5pfd9u7YgYcnNL8Vy+H8he/V121FPx+c8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcnpmHE7hA7IxIR+AauBtCXPGKgTyiGo6MyDhsDfsRPXS/9AhJiSf6CQEyFmfcxHZ
         mGnhJUxa+C5hKLhqqdl2y7AQAJDUS32ClCCZ8IB5LzhCvBe5zmcP7Ac60iD/XI7aDv
         mAi8sBJJxAf0uDg5Wl1ioaeMJMcIx09dbnbj+Y58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 043/229] can: kvaser_usb_leaf: Fix CAN state after restart
Date:   Mon, 24 Oct 2022 13:29:22 +0200
Message-Id: <20221024113000.483163493@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 0be1a655fe68c8e6dcadbcbddb69cf2fb29881f5 upstream.

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
Link: https://lore.kernel.org/all/20221010150829.199676-5-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1435,6 +1435,8 @@ static int kvaser_usb_leaf_set_mode(stru
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;
+
+		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 		break;
 	default:
 		return -EOPNOTSUPP;


