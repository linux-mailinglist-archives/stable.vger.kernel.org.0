Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB37F66C57B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjAPQGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjAPQGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7345123864
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E3E5B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77428C433D2;
        Mon, 16 Jan 2023 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885065;
        bh=44HSyK6uZDz6w8zpJGlM/OacizFb/ohe739n6uWOtP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuS9z3tPwZ6TKvYnWUh4HU8686wcy4h0bsb75G/PEyuIDa9AjEV/pHzfyD0YfWj1D
         eil2UpSTIveHMhQdBKIOktShawJMJSFBElNgj74h5EJapn+tUj8Df5Ux30KXQfhXVr
         M2jpQ7OiwWmA3InSe9b4Id5pxU+Wodw+yyVj5bf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Mattia Dongili <malattia@linux.it>
Subject: [PATCH 5.15 32/86] platform/x86: sony-laptop: Dont turn off 0x153 keyboard backlight during probe
Date:   Mon, 16 Jan 2023 16:51:06 +0100
Message-Id: <20230116154748.420456677@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit ad75bd85b1db69c97eefea07b375567821f6ef58 upstream.

The 0x153 version of the kbd backlight control SNC handle has no separate
address to probe if the backlight is there.

This turns the probe call into a set keyboard backlight call with a value
of 0 turning off the keyboard backlight.

Skip probing when there is no separate probe address to avoid this.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1583752
Fixes: 800f20170dcf ("Keyboard backlight control for some Vaio Fit models")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mattia Dongili <malattia@linux.it>
Link: https://lore.kernel.org/r/20221213122943.11123-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/sony-laptop.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1892,14 +1892,21 @@ static int sony_nc_kbd_backlight_setup(s
 		break;
 	}
 
-	ret = sony_call_snc_handle(handle, probe_base, &result);
-	if (ret)
-		return ret;
+	/*
+	 * Only probe if there is a separate probe_base, otherwise the probe call
+	 * is equivalent to __sony_nc_kbd_backlight_mode_set(0), resulting in
+	 * the keyboard backlight being turned off.
+	 */
+	if (probe_base) {
+		ret = sony_call_snc_handle(handle, probe_base, &result);
+		if (ret)
+			return ret;
 
-	if ((handle == 0x0137 && !(result & 0x02)) ||
-			!(result & 0x01)) {
-		dprintk("no backlight keyboard found\n");
-		return 0;
+		if ((handle == 0x0137 && !(result & 0x02)) ||
+				!(result & 0x01)) {
+			dprintk("no backlight keyboard found\n");
+			return 0;
+		}
 	}
 
 	kbdbl_ctl = kzalloc(sizeof(*kbdbl_ctl), GFP_KERNEL);


