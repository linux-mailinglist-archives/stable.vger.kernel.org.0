Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2C14F3A8C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381542AbiDELqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354890AbiDEKQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F154D13D09;
        Tue,  5 Apr 2022 03:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7423B81BC0;
        Tue,  5 Apr 2022 10:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2042BC385A2;
        Tue,  5 Apr 2022 10:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153007;
        bh=JYK4yYmxxNHgDv07Zrecz68AmrIqH+sR9RKYuvJdm1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eu9ZBh5Tk811ICPl0N4/lw/rmd+xN1O4cSzIKTGgZMaQobDUBNny1d6JmW5//rDLV
         0yCOTQKwZZEbNin+O76nv0F8YufinG5hOqSLltB2mISV67kVylSm18y+UXcQKYKBZ8
         8vedA1T/WzisD4RQprtXybl8T9q3iS66AFG4uJtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 067/599] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Date:   Tue,  5 Apr 2022 09:26:01 +0200
Message-Id: <20220405070300.820802423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

commit 8b188fba75195745026e11d408e4a7e94e01d701 upstream.

This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.

The touchpad present in the Dell Precision 7550 and 7750 laptops
reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
the device is not a clickpad, it is a touchpad with physical buttons.

In order to fix this issue, a quirk for the device was introduced in
libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:

	[Precision 7x50 Touchpad]
	MatchBus=i2c
	MatchUdevType=touchpad
	MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
	AttrInputPropDisable=INPUT_PROP_BUTTONPAD

However, because of the change introduced in 37ef4c19b4 ("Input: clear
BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
anymore breaking the device right click button and making impossible to
workaround it in user space.

In order to avoid breakage on other present or future devices, revert
the patch causing the issue.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220321184404.20025-1-jose.exposito89@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/input.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2179,12 +2179,6 @@ int input_register_device(struct input_d
 	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
 	__clear_bit(KEY_RESERVED, dev->keybit);
 
-	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
-	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
-		__clear_bit(BTN_RIGHT, dev->keybit);
-		__clear_bit(BTN_MIDDLE, dev->keybit);
-	}
-
 	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
 	input_cleanse_bitmasks(dev);
 


