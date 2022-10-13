Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53A05FE261
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJMTGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJMTGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4303D63CE;
        Thu, 13 Oct 2022 12:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59912B82034;
        Thu, 13 Oct 2022 17:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1687C433C1;
        Thu, 13 Oct 2022 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683902;
        bh=45B25suZiRTyMNLHbM6xw8qTu27E00Fp19ufaiOX5r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMVSl6Bd+cHXpjEVfdlF8o+AabboTQLXF7SrryLfl41KF6iKzgCENlGkme75nb61u
         fZqvnXsooImKbXKiRKgrIHw4zt3rn/5tCdg4IYnIia4HItti2MS3gDnB4aC+S8FtqX
         9tQ0/WsnaPR2dYqm9qzy8oWt/BPeB3zTt9rYOkTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Gutman <aicommander@gmail.com>,
        Pavel Rojtberg <rojtberg@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 25/27] Input: xpad - fix wireless 360 controller breaking after suspend
Date:   Thu, 13 Oct 2022 19:52:54 +0200
Message-Id: <20221013175144.475451252@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
References: <20221013175143.518476113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1991,7 +1991,6 @@ static struct usb_driver xpad_driver = {
 	.disconnect	= xpad_disconnect,
 	.suspend	= xpad_suspend,
 	.resume		= xpad_resume,
-	.reset_resume	= xpad_resume,
 	.id_table	= xpad_table,
 };
 


