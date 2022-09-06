Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B505AEC76
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240635AbiIFOIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbiIFOGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C6785A91;
        Tue,  6 Sep 2022 06:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 212CE61557;
        Tue,  6 Sep 2022 13:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC37C433D7;
        Tue,  6 Sep 2022 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471867;
        bh=17sx56KLKhxrqHmDM3TMAmXikZVYkvO5J/4XnRroi5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=balKwnhUawtGJkRg8tU0wuYspv8IT/K2ZtMdaXN4Z20/znCScMA9kMeviBUlIk7so
         Wa6XDanSOOTxXA8nj48diVJV7rPyUsJKXib5bTdXAJVGCkMn/lP/x+4/ZYrDg34V1i
         ebOo0QspJFL80OKQfHU9pZv79nkwj3gy5/mK48d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.19 065/155] musb: fix USB_MUSB_TUSB6010 dependency
Date:   Tue,  6 Sep 2022 15:30:13 +0200
Message-Id: <20220906132832.187312657@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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


