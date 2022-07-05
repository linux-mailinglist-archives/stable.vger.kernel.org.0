Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F96566AE6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiGEMC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbiGEMC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3934183B4;
        Tue,  5 Jul 2022 05:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 486E3CE1B86;
        Tue,  5 Jul 2022 12:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E11C341C7;
        Tue,  5 Jul 2022 12:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022521;
        bh=vL0arXI7ti0jT6m6fv3+MgrGNiDpDyse8ySN/98+12c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yimnsKX5kppxsWYh4gYCCQpc4No4Yqa/Mv/IcY0x/PjVnoRi1/qlQvyfj/+Sn0r+h
         UMpS8Ho0MlzVK73YWAxa0SUEixHpEsPu9jfIjOcW81NnXBlEv74T355S+ouritiIIW
         pSWOCUBb/kcsSTL9sB8/6R/JkAC4IGbSadLJFQeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 09/29] usbnet: fix memory allocation in helpers
Date:   Tue,  5 Jul 2022 13:57:57 +0200
Message-Id: <20220705115606.618114319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
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
@@ -2002,7 +2002,7 @@ static int __usbnet_read_cmd(struct usbn
 		   cmd, reqtype, value, index, size);
 
 	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmalloc(size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	}
@@ -2034,7 +2034,7 @@ static int __usbnet_write_cmd(struct usb
 		   cmd, reqtype, value, index, size);
 
 	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	} else {


