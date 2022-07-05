Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52F6566B38
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiGEMFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiGEMEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFC6186EF;
        Tue,  5 Jul 2022 05:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F41F61806;
        Tue,  5 Jul 2022 12:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A24C341C7;
        Tue,  5 Jul 2022 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022643;
        bh=32NJMC0s5CjllmvErXiC++NFIfdW1o0siO8fgtY6M6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5XUYbHnDnsGGyb+iLx2IcE7u7KLUFICwM0Z9l3mAJjaytXmVJt3jRO7OPf+ijwV6
         mv++jDpIPadnaGFtiGZyijNy3cIHQ3onJeDHkkp81o49j1Oz8rROm/PFC9Hz0Ttn6I
         kRIrRnfgOcgav7kzXpjLf1q4NuSFOnEX5y71+yr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 17/58] usbnet: fix memory allocation in helpers
Date:   Tue,  5 Jul 2022 13:57:53 +0200
Message-Id: <20220705115610.749856705@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
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
@@ -1987,7 +1987,7 @@ static int __usbnet_read_cmd(struct usbn
 		   cmd, reqtype, value, index, size);
 
 	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmalloc(size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	}
@@ -2019,7 +2019,7 @@ static int __usbnet_write_cmd(struct usb
 		   cmd, reqtype, value, index, size);
 
 	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	} else {


