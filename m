Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAE5501436
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbiDNNvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343579AbiDNNjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C93321E36;
        Thu, 14 Apr 2022 06:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D245561CB7;
        Thu, 14 Apr 2022 13:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC47DC385A1;
        Thu, 14 Apr 2022 13:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943267;
        bh=2S2+NOXo+OcZw3EPwEqHG9SqQk6hR+vwqRrSDaCltZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlUR9I95DTqr3FJIpB74uFQ4/N5wXZqolGAJ0k8tVlUJfRELLZOa4ecRr94Jy5han
         +SK/qSGtI6O4QhFk8sqpSLLyyMBSAkzgTi+dIm0L/zxCyVnhd66WUwH9rP9dcidx1v
         2KUb28DKeOv2romicEqVpgZH5eehEp7VloP+BvYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 054/475] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Date:   Thu, 14 Apr 2022 15:07:19 +0200
Message-Id: <20220414110856.665296106@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -2181,12 +2181,6 @@ int input_register_device(struct input_d
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
 


