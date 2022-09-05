Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889CB5AD159
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 13:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiIELHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 07:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiIELHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 07:07:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A926119294
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 04:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E30361220
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 11:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59451C433D6;
        Mon,  5 Sep 2022 11:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662376026;
        bh=bo9nD6dXJAj54oF03d8gd5Y5MQlRy0HPMHvRJ9wGh1w=;
        h=Subject:To:From:Date:From;
        b=b1VbeRxwiiaH+KhEfMjTd+OtJNxrW1VBfTxoNfADK1qEi+bUZB4kFVZaNvC7VqjeD
         AqwvQQU5teIWWG3tBFygqx/ORmOXLw6xnPWbhhYONEv3hUrTIYTaU/nhfDTjjatiHK
         8yASGbhKGVC+Y/evfQaOq8Dpk2yxB5zxlCvSjWms=
Subject: patch "USB: core: Fix RST error in hub.c" added to usb-linus
To:     stern@rowland.harvard.edu, bagasdotme@gmail.com,
        gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Sep 2022 13:07:04 +0200
Message-ID: <16623760241494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    USB: core: Fix RST error in hub.c

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 766a96dc558385be735a370db867e302c8f22153 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 1 Sep 2022 10:36:34 -0400
Subject: USB: core: Fix RST error in hub.c

A recent commit added an invalid RST expression to a kerneldoc comment
in hub.c.  The fix is trivial.

Fixes: 9c6d778800b9 ("USB: core: Prevent nested device-reset calls")
Cc: <stable@vger.kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YxDDcsLtRZ7c20pq@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d4b1e70d1498..bbab424b0d55 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6039,7 +6039,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
  *
  * Return: The same as for usb_reset_and_verify_device().
  * However, if a reset is already in progress (for instance, if a
- * driver doesn't have pre_ or post_reset() callbacks, and while
+ * driver doesn't have pre_reset() or post_reset() callbacks, and while
  * being unbound or re-bound during the ongoing reset its disconnect()
  * or probe() routine tries to perform a second, nested reset), the
  * routine returns -EINPROGRESS.
-- 
2.37.3


