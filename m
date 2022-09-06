Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A705AEB2B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiIFNux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239745AbiIFNtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B8028E17;
        Tue,  6 Sep 2022 06:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18167CE1777;
        Tue,  6 Sep 2022 13:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F304EC433C1;
        Tue,  6 Sep 2022 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471561;
        bh=17sx56KLKhxrqHmDM3TMAmXikZVYkvO5J/4XnRroi5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhBIS0O7FjwacqWKxUDb9dd1ImoMO8JWS7wTHYS7oZjEHXRCi++QPfpTusfLxesXf
         LcR4GTUj6nU0npGLnxnvDKxAu2d4qHZsGCEJgUNnhEr4KARO1RBNDBg5T9JCBJOrll
         qhIgN/GnBsp00q43dzZQDzgNI8aZOK+Mo0YNEC2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 036/107] musb: fix USB_MUSB_TUSB6010 dependency
Date:   Tue,  6 Sep 2022 15:30:17 +0200
Message-Id: <20220906132823.324786936@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arnd Bergmann <arnd@arndb.de>

commit a3f2fd22743fc56dd5e3896a3fbddd276df1577f upstream.

Turning on NOP_USB_XCEIV as builtin broke the TUSB6010 driver because
of an older issue with the depencency.

It is not necessary to forbid NOP_USB_XCEIV=y in combination with
USB_MUSB_HDRC=m, but only the reverse, which causes the link failure
from the original Kconfig change.

Use the correct dependency to still allow NOP_USB_XCEIV=n or
NOP_USB_XCEIV=y but forbid NOP_USB_XCEIV=m when USB_MUSB_HDRC=m
to fix the multi_v7_defconfig for tusb.

Fixes: ab37a7a890c1 ("ARM: multi_v7_defconfig: Make NOP_USB_XCEIV driver built-in")
Fixes: c0442479652b ("usb: musb: Fix randconfig build issues for Kconfig options")
Cc: stable <stable@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20220818135737.3143895-10-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -86,7 +86,7 @@ config USB_MUSB_TUSB6010
 	tristate "TUSB6010"
 	depends on HAS_IOMEM
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
-	depends on NOP_USB_XCEIV = USB_MUSB_HDRC # both built-in or both modules
+	depends on NOP_USB_XCEIV!=m || USB_MUSB_HDRC=m
 
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"


