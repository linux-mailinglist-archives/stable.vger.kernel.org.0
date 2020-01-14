Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048EE13A556
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgANKGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgANKGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:06:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E76824681;
        Tue, 14 Jan 2020 10:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996408;
        bh=I2LKLTtBWS4PoSIgSlNuZBGxHpJKQwjuaBfWGWzmPiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoOHi580/XXtel+8yhK3KsO1arIJ8tPCYcgjyQFz0y3p7ajEb+99vBcZiwct+NF60
         GKtmo/kV8JDWrlzcKTQkDPHC19mXhX7qcsY6c96GvSW7gdmVF996nw7zOGZclUvydQ
         qkP6NILdBErQr45V0BbxhCE8pM0B8tbgvh/s7ZP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 5.4 71/78] ath10k: fix memory leak
Date:   Tue, 14 Jan 2020 11:01:45 +0100
Message-Id: <20200114094402.874361267@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit b8d17e7d93d2beb89e4f34c59996376b8b544792 upstream.

In ath10k_usb_hif_tx_sg the allocated urb should be released if
usb_submit_urb fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath10k/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -443,6 +443,7 @@ static int ath10k_usb_hif_tx_sg(struct a
 			ath10k_dbg(ar, ATH10K_DBG_USB_BULK,
 				   "usb bulk transmit failed: %d\n", ret);
 			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			ret = -EINVAL;
 			goto err_free_urb_to_pipe;
 		}


