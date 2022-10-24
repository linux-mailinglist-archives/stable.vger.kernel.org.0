Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D38960A404
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJXMFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiJXMC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:02:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE1B23EB0;
        Mon, 24 Oct 2022 04:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47F1EB8117E;
        Mon, 24 Oct 2022 11:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C2C433C1;
        Mon, 24 Oct 2022 11:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612041;
        bh=zZ6aCnvvIvMD/DtvvB7qbtS2ts7lyXMgsQSGtvWJf1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cf5tnW9jl781uCuhyFZd5zBA/iLc01IIH16bwrXl164xnE4Twgm7yiLg6ot61+7w+
         JsH2gcWtUFZ3hxpCuzY0Z25PLOw4nI7kM4SKeBXD5+JrWoEAmljyH6K1ZTBbGUUvWG
         WqRzO740Y3HgAf2D9UQb1bJcMHyRJA3yPXkcnCG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Gutman <aicommander@gmail.com>,
        Pavel Rojtberg <rojtberg@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 048/210] Input: xpad - fix wireless 360 controller breaking after suspend
Date:   Mon, 24 Oct 2022 13:29:25 +0200
Message-Id: <20221024112958.545652058@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

From: Cameron Gutman <aicommander@gmail.com>

commit a17b9841152e7f4621619902b347e2cc39c32996 upstream.

Suspending and resuming the system can sometimes cause the out
URB to get hung after a reset_resume. This causes LED setting
and force feedback to break on resume. To avoid this, just drop
the reset_resume callback so the USB core rebinds xpad to the
wireless pads on resume if a reset happened.

A nice side effect of this change is the LED ring on wireless
controllers is now set correctly on system resume.

Cc: stable@vger.kernel.org
Fixes: 4220f7db1e42 ("Input: xpad - workaround dead irq_out after suspend/ resume")
Signed-off-by: Cameron Gutman <aicommander@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20220818154411.510308-3-rojtberg@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -2000,7 +2000,6 @@ static struct usb_driver xpad_driver = {
 	.disconnect	= xpad_disconnect,
 	.suspend	= xpad_suspend,
 	.resume		= xpad_resume,
-	.reset_resume	= xpad_resume,
 	.id_table	= xpad_table,
 };
 


