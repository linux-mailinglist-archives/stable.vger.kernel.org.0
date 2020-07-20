Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2F22685E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388343AbgGTQSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732566AbgGTQN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3479620734;
        Mon, 20 Jul 2020 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261608;
        bh=2VjVDT0gFe8cQ3yxWyfhdTGBpQoSpI9OFZRQlmlxDNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kW4COPlRrOsQFW8PzzrZfpssVkDuttvsHzJiWEx6AdnaUEBxdor66JkjGOPqUIps
         Yq8JVaM6kIHyTUvCRh03HrGD+FP5V9KKW7POVSaqNgqgSl1rpSZQccmz5DFBtjrDuZ
         L9xACPoFRDUGe3fvZiIE/tBy4Ze9I0GoNKyy0Ucw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Harry Cutts <hcutts@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.7 147/244] HID: logitech-hidpp: avoid repeated "multiplier = " log messages
Date:   Mon, 20 Jul 2020 17:36:58 +0200
Message-Id: <20200720152832.843175218@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

commit e13762abf38ead29071407f32b9dcec38f21dc34 upstream.

These messages appear each time the mouse wakes from sleep, in my case
(Logitech M705), every minute or so.
Let's downgrade them to the "debug" level so they don't fill the kernel log
by default.

While we are at it, let's make clear that this is a wheel multiplier (and
not, for example, XY movement multiplier).

Fixes: 4435ff2f09a2 ("HID: logitech: Enable high-resolution scrolling on Logitech mice")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Reviewed-by: Harry Cutts <hcutts@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-hidpp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3146,7 +3146,7 @@ static int hi_res_scroll_enable(struct h
 		multiplier = 1;
 
 	hidpp->vertical_wheel_counter.wheel_multiplier = multiplier;
-	hid_info(hidpp->hid_dev, "multiplier = %d\n", multiplier);
+	hid_dbg(hidpp->hid_dev, "wheel multiplier = %d\n", multiplier);
 	return 0;
 }
 


