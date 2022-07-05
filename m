Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E8C566AEA
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiGEMDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiGEMCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3700186C8;
        Tue,  5 Jul 2022 05:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724E66183D;
        Tue,  5 Jul 2022 12:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8127EC341CB;
        Tue,  5 Jul 2022 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022537;
        bh=9nKadkDKcu+bSnGkvWm/Kf03ITK4gAcE6KB+/jUdhko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qtn2Zjsyy/rkhLUAI6tVtcPMd0D0prJ9m5kn2ZCtA1vOinaJuTInQ9T2wABY49wUt
         JIceia5K1iWi7YjmrU1LI38Mydf15iYdSI0Q//WjHBJCjGITdJVBmCRJAFqP8X03Pj
         qZv7/QdJaT+9oFktw0bdUeJzsLC5r1TW1rtqaSLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 13/33] usbnet: fix memory allocation in helpers
Date:   Tue,  5 Jul 2022 13:58:05 +0200
Message-Id: <20220705115607.098490569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit e65af5403e462ccd7dff6a045a886c64da598c2e upstream.

usbnet provides some helper functions that are also used in
the context of reset() operations. During a reset the other
drivers on a device are unable to operate. As that can be block
drivers, a driver for another interface cannot use paging
in its memory allocations without risking a deadlock.
Use GFP_NOIO in the helpers.

Fixes: 877bd862f32b8 ("usbnet: introduce usbnet 3 command helpers")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220628093517.7469-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1998,7 +1998,7 @@ static int __usbnet_read_cmd(struct usbn
 		   cmd, reqtype, value, index, size);
 
 	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmalloc(size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	}
@@ -2030,7 +2030,7 @@ static int __usbnet_write_cmd(struct usb
 		   cmd, reqtype, value, index, size);
 
 	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	} else {


