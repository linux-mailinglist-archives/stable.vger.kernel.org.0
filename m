Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B545EA3B3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiIZLbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiIZLap (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:30:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435F36CD0D;
        Mon, 26 Sep 2022 03:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC866B80957;
        Mon, 26 Sep 2022 10:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022BAC433C1;
        Mon, 26 Sep 2022 10:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188915;
        bh=GdDUD7KOy9ItThcRwpu3l9kw+H45iGoDS4QgSG4WwD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoLA/GXwGlq0IPnP8Mkm9Q4B5U4Ku2JYXkz5qEVuouj99KYcSH7D2wNalfz9DuRC2
         e5SZTA9TUgfO6nLR8i4TNfDY68cWvvh/6HKqTvalrLhH5ksJn7LEQ/yUqtfsZGEgnJ
         6akRxZjOlDO4WD0hvFAlq/SmWCY8N7Bypg75wQiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 014/207] Revert "usb: add quirks for Lenovo OneLink+ Dock"
Date:   Mon, 26 Sep 2022 12:10:03 +0200
Message-Id: <20220926100807.118539823@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 58bfe7d8e31014d7ce246788df99c56e3cfe6c68 ]

This reverts commit 3d5f70949f1b1168fbb17d06eb5c57e984c56c58.

The quirk does not work properly, more work is needed to determine what
should be done here.

Reported-by: Oliver Neukum <oneukum@suse.com>
Cc: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Cc: stable <stable@kernel.org>
Fixes: 3d5f70949f1b ("usb: add quirks for Lenovo OneLink+ Dock")
Link: https://lore.kernel.org/r/9a17ea86-079f-510d-e919-01bc53a6d09f@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 999b7c9697fc..f99a65a64588 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -437,10 +437,6 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
-	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
-	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },
-	{ USB_DEVICE(0x17ef, 0x1019), .driver_info = USB_QUIRK_RESET_RESUME },
-
 	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
 	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
 
-- 
2.35.1



