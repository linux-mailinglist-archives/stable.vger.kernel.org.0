Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E56566A9A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiGEMAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiGEMAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:00:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FE317E34;
        Tue,  5 Jul 2022 05:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D317B817D4;
        Tue,  5 Jul 2022 12:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958FEC341CD;
        Tue,  5 Jul 2022 12:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022408;
        bh=MDRErYeUWSJwKsBCQCGe+p0aMtjXUNffMWGsG7Pl+a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8cyUgyEuBD8O86NMNxSE5OiwAlsZgiDqWqCfm62axmP4KGxoOGxSRPCjs42ubQya
         f6pBbLeR/6oaDuFG0CtV65ItK0BV4XCYnugvLkbFfC5vOIwdctKmUFSQHx3V4HHQ9w
         1YuJEf7ZOq9AYdOnJYWFChtJNXzHpLj7ka1rmgeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 06/29] usbnet: fix memory allocation in helpers
Date:   Tue,  5 Jul 2022 13:57:47 +0200
Message-Id: <20220705115605.933108860@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
References: <20220705115605.742248854@linuxfoundation.org>
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
@@ -1952,7 +1952,7 @@ static int __usbnet_read_cmd(struct usbn
 		   cmd, reqtype, value, index, size);
 
 	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmalloc(size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	}
@@ -1984,7 +1984,7 @@ static int __usbnet_write_cmd(struct usb
 		   cmd, reqtype, value, index, size);
 
 	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	} else {


