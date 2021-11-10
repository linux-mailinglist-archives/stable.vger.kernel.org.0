Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9116244C753
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhKJSuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233118AbhKJSsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:48:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A26B61208;
        Wed, 10 Nov 2021 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569964;
        bh=2jRt6yceGOBLuclUlbzmWCLpOlfThvDjVNhnByIJyYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7ZLrjCrgyHg/zWeH/ZCb7/fQvv7DilaoNOthZ+kv+cNokhAdCy3wCB9IpAYPDMBu
         RgpvsTCRNllIjg9lJnlbkHkbBiSkkDb7mNYaxH/x+bHVG3+bVLi74rjxtstS5l9XV7
         SnqSXFIrSu4VU2IZGb7N4RIUFQHg6YPxrVpwaSXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 22/22] rsi: fix control-message timeout
Date:   Wed, 10 Nov 2021 19:43:42 +0100
Message-Id: <20211110182003.374797661@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.666244094@linuxfoundation.org>
References: <20211110182002.666244094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 541fd20c3ce5b0bc39f0c6a52414b6b92416831c upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeout.

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable@vger.kernel.org      # 3.15
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211025120522.6045-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -48,7 +48,7 @@ static int rsi_usb_card_write(struct rsi
 			      (void *)seg,
 			      (int)len,
 			      &transfer,
-			      HZ * 5);
+			      USB_CTRL_SET_TIMEOUT);
 
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,


