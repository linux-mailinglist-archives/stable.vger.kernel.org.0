Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAC322695E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgGTQB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732594AbgGTQB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B405420684;
        Mon, 20 Jul 2020 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260916;
        bh=CuMFnDdWW6Rj3x2ceG6X3sby4sU4hKuLNenESjiWw88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDAagDLMg4na8fttCAUbdnEAI9YqE2/CVZF4djU6MMyV4JrgDFI5di3wU+KFVDDeS
         fQDiPH0hj9q+tetaqbMpVUBZ2EEIpcQfH6tPO/7EMvaH5JZ5v9o/kF53TECrazMzAA
         a7es4uwk36syu3dGhPXN8tC9/Mm6jESRIgarDdX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Harry Cutts <hcutts@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 143/215] HID: logitech-hidpp: avoid repeated "multiplier = " log messages
Date:   Mon, 20 Jul 2020 17:37:05 +0200
Message-Id: <20200720152826.994050088@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
@@ -2964,7 +2964,7 @@ static int hi_res_scroll_enable(struct h
 		multiplier = 1;
 
 	hidpp->vertical_wheel_counter.wheel_multiplier = multiplier;
-	hid_info(hidpp->hid_dev, "multiplier = %d\n", multiplier);
+	hid_dbg(hidpp->hid_dev, "wheel multiplier = %d\n", multiplier);
 	return 0;
 }
 


