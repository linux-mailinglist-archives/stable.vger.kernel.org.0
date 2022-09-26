Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954EE5EA08C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiIZKkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbiIZKiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C79853028;
        Mon, 26 Sep 2022 03:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E132860B60;
        Mon, 26 Sep 2022 10:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51CAC433D6;
        Mon, 26 Sep 2022 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187758;
        bh=w9vZUF8bSrbf5AW2P6WQoeDQYs92qFXWsr7CQgk/3HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdcT27ZoGg8LhmyP85xJJITJenp7U3IEFcEQ+k6pDXL2Hqx8aMH5G/VySNi3bjH7l
         sw+DSaKhNlcQZefPEjlGzoBpalDkLJKBXDsQIXqhGp+9JueiPedeoFQh2xx/Ays/VA
         SeMBXCzzKqtoiKeBHw3h2vpRhXMGk3gZN+Ioctq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/120] Revert "usb: add quirks for Lenovo OneLink+ Dock"
Date:   Mon, 26 Sep 2022 12:11:24 +0200
Message-Id: <20220926100752.653206499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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
index dd7947547054..f8f2de7899a9 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -438,10 +438,6 @@ static const struct usb_device_id usb_quirk_list[] = {
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



