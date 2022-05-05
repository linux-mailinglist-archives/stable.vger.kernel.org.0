Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406DA51CC20
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386345AbiEEWha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbiEEWh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:37:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89035DBF5
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:33:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5744AB830E6
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C627EC385A8;
        Thu,  5 May 2022 22:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790025;
        bh=EX9FyHBWvyCLWQrSaYDrZTQ/VcOI34+CzH9pzHmurqk=;
        h=Subject:To:From:Date:From;
        b=qLmWfnISgxBOBRR3B4e7H3cERDe/Hl+tIxge+QIxwHPwqffd8PAS+BqOlaizgxPvF
         TR6zEr5Z1wKnXn+yGS8y8K5k0fAtgeNTtU/B5HfTBaX05yUAXeBKAJsvjUIBBok+ej
         NoGBnghPvBtZdndvIQvf/HVR1vRXXMz8Z2dmDXpA=
Subject: patch "usb: cdc-wdm: fix reading stuck on device close" added to usb-linus
To:     ryazanov.s.a@gmail.com, gregkh@linuxfoundation.org,
        oneukum@suse.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 22:18:16 +0200
Message-ID: <1651781896192206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdc-wdm: fix reading stuck on device close

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 01e01f5c89773c600a9f0b32c888de0146066c3a Mon Sep 17 00:00:00 2001
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Sun, 1 May 2022 20:58:28 +0300
Subject: usb: cdc-wdm: fix reading stuck on device close

cdc-wdm tracks whether a response reading request is in-progress and
blocks the next request from being sent until the previous request is
completed. As soon as last user closes the cdc-wdm device file, the
driver cancels any ongoing requests, resets the pending response
counter, but leaves the response reading in-progress flag
(WDM_RESPONDING) untouched.

So if the user closes the device file during the response receive
request is being performed, no more data will be obtained from the
modem. The request will be cancelled, effectively preventing the
WDM_RESPONDING flag from being reseted. Keeping the flag set will
prevent a new response receive request from being sent, permanently
blocking the read path. The read path will staying blocked until the
module will be reloaded or till the modem will be re-attached.

This stuck has been observed with a Huawei E3372 modem attached to an
OpenWrt router and using the comgt utility to set up a network
connection.

Fix this issue by clearing the WDM_RESPONDING flag on the device file
close.

Without this fix, the device reading stuck can be easily reproduced in a
few connection establishing attempts. With this fix, a load test for
modem connection re-establishing worked for several hours without any
issues.

Fixes: 922a5eadd5a3 ("usb: cdc-wdm: Fix race between autosuspend and reading from the device")
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220501175828.8185-1-ryazanov.s.a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7f2c83f299d3..eebe782380fb 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -774,6 +774,7 @@ static int wdm_release(struct inode *inode, struct file *file)
 			poison_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
 			unpoison_urbs(desc);
-- 
2.36.0


