Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBCD5EA1E0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiIZK7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiIZK6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E754DF20;
        Mon, 26 Sep 2022 03:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16BB860B5E;
        Mon, 26 Sep 2022 10:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C390C433C1;
        Mon, 26 Sep 2022 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188128;
        bh=Uxwm54e8RpQZ7VZdhu2ZIac0OER8M/TjZNPKE6rmbcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tL5FNZYBcPyHvihnSECA5d8ERXGMIa1f4LSpy71amkbYDIBqU9d9klLi/U+FehpGT
         i75x/SS/nxQGswPusw81lW3IS/SQJiiqZUcdEJlAbyNlN5EwgS/55MH+9xZrcmNoGD
         gppLQ8/OeS0maKqlr2Zexs7EQRKae8XbbxM8wZxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 049/141] media: flexcop-usb: fix endpoint type check
Date:   Mon, 26 Sep 2022 12:11:15 +0200
Message-Id: <20220926100756.220221889@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 763679f0eeff0185fc431498849bbc1c24460875 upstream.

Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint
type") tried to add an endpoint type sanity check for the single
isochronous endpoint but instead broke the driver by checking the wrong
descriptor or random data beyond the last endpoint descriptor.

Make sure to check the right endpoint descriptor.

Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
Cc: Oliver Neukum <oneukum@suse.com>
Cc: stable@vger.kernel.org	# 5.9
Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20220822151027.27026-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -512,7 +512,7 @@ static int flexcop_usb_init(struct flexc
 
 	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
 		return -ENODEV;
-	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[1].desc))
+	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
 		return -ENODEV;
 
 	switch (fc_usb->udev->speed) {


