Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E7264A188
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiLLNlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiLLNlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:41:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31B13F45
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC366105A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9729BC433F1;
        Mon, 12 Dec 2022 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852435;
        bh=NPuH5eEihbns5mY7bxhRIuX8bLoq79mjfxcvJ125rCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M50Yh1TXLZ0FMjwhoZmbAF++ipFBJu7oaPBVJ2HyCMoAC2wgpmH4PlxInf2POONbI
         AD4ZNE/N7gkhKNTqbOZcbzd5qWZcUhL45YYpR6vGxHb53+kr0a6q7EPpQJWAKaxU4U
         J2LrUcbmVEoOr981h1BhbYsc3RKnhlUJXHPE+yQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 079/157] HID: fix I2C_HID not selected when I2C_HID_OF_ELAN is
Date:   Mon, 12 Dec 2022 14:17:07 +0100
Message-Id: <20221212130937.932046739@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 2afac81dd16544d825f309fd992d2af6304353df upstream.

When I2C_HID_OF_ELAN is set, we need to turn on I2C_HID_CORE to
ensure we get all the HID requirements.

Fixes: bd3cba00dcc6 ("HID: i2c-hid: elan: Add support for Elan eKTH6915 i2c-hid touchscreens")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/i2c-hid/Kconfig b/drivers/hid/i2c-hid/Kconfig
index 5273ee2bb134..d65abe65ce73 100644
--- a/drivers/hid/i2c-hid/Kconfig
+++ b/drivers/hid/i2c-hid/Kconfig
@@ -66,6 +66,6 @@ endmenu
 
 config I2C_HID_CORE
 	tristate
-	default y if I2C_HID_ACPI=y || I2C_HID_OF=y || I2C_HID_OF_GOODIX=y
-	default m if I2C_HID_ACPI=m || I2C_HID_OF=m || I2C_HID_OF_GOODIX=m
+	default y if I2C_HID_ACPI=y || I2C_HID_OF=y || I2C_HID_OF_ELAN=y || I2C_HID_OF_GOODIX=y
+	default m if I2C_HID_ACPI=m || I2C_HID_OF=m || I2C_HID_OF_ELAN=m || I2C_HID_OF_GOODIX=m
 	select HID
-- 
2.38.1



