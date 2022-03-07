Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269864D0119
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 15:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbiCGOYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 09:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiCGOYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 09:24:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D469F6E8F0;
        Mon,  7 Mar 2022 06:23:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F1C861241;
        Mon,  7 Mar 2022 14:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48F5C340E9;
        Mon,  7 Mar 2022 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646663036;
        bh=eoQmXkZ9PKN+imNj8EDFAlgg9aAhIqjAGVg6hhDw9aU=;
        h=From:To:Cc:Subject:Date:From;
        b=Zr+q0CmN8ndgh6ek5v26M0jqErfNfJ1A1+tdbpXfUg9DTYM6nh+v8jGbFWYuIxl+A
         iqckaxQnDX6pu4qqVY2Ns6RlqQHKE2S9pXJTKEWouWXpxL2OdBn3zt0yViQZtNEqfq
         K/x4giA/ez3vs+cf/lRT0KgIwHs3/bsbDMn9Yvs3FljcbPKU5o4fT1AP3NjOWuJWJi
         JVWjcyaOY0Mn52LZmfBY6gUqsKfimmc3Xa8odujNgJGDdvtYa8Tixz9dVRu992aNeH
         XHrHG+UweMkPJQgb8n3agdGgpnKZ2JbWoYmvRRbTs3d0AShgXTHVUB1SCLVyDkxhYX
         ur+d87DhCYywg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nREH9-0005Bo-7S; Mon, 07 Mar 2022 15:23:51 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Maty=C3=A1=C5=A1=20Kroupa?= <kroupa.matyas@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: pl2303: fix GS type detection
Date:   Mon,  7 Mar 2022 15:23:19 +0100
Message-Id: <20220307142319.19919-1-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At least some PL2303GS have a bcdDevice of 0x605 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Reported-by: Matyáš Kroupa <kroupa.matyas@gmail.com>
Link: https://lore.kernel.org/r/165de6a0-43e9-092c-2916-66b115c7fbf4@gmail.com
Cc: stable@vger.kernel.org	# 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/pl2303.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index e2ef761ed39c..88b284d61681 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -436,6 +436,7 @@ static int pl2303_detect_type(struct usb_serial *serial)
 		case 0x105:
 		case 0x305:
 		case 0x405:
+		case 0x605:
 			/*
 			 * Assume it's an HXN-type if the device doesn't
 			 * support the old read request value.
-- 
2.34.1

