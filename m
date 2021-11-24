Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919AB45BCF7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbhKXMeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:34:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243089AbhKXMcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:32:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3F661185;
        Wed, 24 Nov 2021 12:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756395;
        bh=zo6ates65FuopZK+2whayNP+CORPcvZzYGcw1Cjm8+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pF8qIeqsktgvbuR4851S7od1Vmo8IcCYq7H50CkkCxzxnMbiXNOpxsBUN1WBdBMnk
         oBlzl4XrZvHyNgkUR7Kt/vXIeh+8MTYuyQXmkW4JfrPImGtygQSDdNcGkgfBB36pqQ
         Capvn6+iC1mGMh+zvX35HZszPBGHLpMDTT2OFaHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Stromdahl <erik.stromdahl@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 039/251] ath10k: fix control-message timeout
Date:   Wed, 24 Nov 2021 12:54:41 +0100
Message-Id: <20211124115711.604659547@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5286132324230168d3fab6ffc16bfd7de85bdfb4 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Cc: stable@vger.kernel.org      # 4.14
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211025120522.6045-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -536,7 +536,7 @@ static int ath10k_usb_submit_ctrl_in(str
 			      req,
 			      USB_DIR_IN | USB_TYPE_VENDOR |
 			      USB_RECIP_DEVICE, value, index, buf,
-			      size, 2 * HZ);
+			      size, 2000);
 
 	if (ret < 0) {
 		ath10k_warn(ar, "Failed to read usb control message: %d\n",


