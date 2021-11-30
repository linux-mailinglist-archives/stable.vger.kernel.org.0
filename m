Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18694638A3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245221AbhK3PFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243829AbhK3O6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A31C0698E6;
        Tue, 30 Nov 2021 06:52:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74AF3CE1A6F;
        Tue, 30 Nov 2021 14:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD98AC53FD2;
        Tue, 30 Nov 2021 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283928;
        bh=r3MKQn3Tt+I2w6NIQiK2igodIlOJhAuklopZIGwLaoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdirG3bqiko2vKZJNGy8LFwnbKVhqVUyGwIREW+oTA3njdV6iGU0yzIE3Y3cwp79c
         Tv7i6Whtqw5yf94UfX31UMgJoqMpxcWXu14GLrHfpOg6MwTFqFlK9fffWZtqEXHaY+
         f1OB31JyrryYc3plKBkcAnQeA75rKfGqZ5S6QYPbqshrLIggtaXH4B2dNYPRWmhGO6
         Zyhx+gZgzm+Mk7cS/+iOC66byaknI5eo6TfaPDLBcCV70pCGfWusp+yyPxEsSOL00e
         1YfxBV7I5NeV9C0g6tLSIjoa+O3KCo4hh7qorYruYohaIoTbAUuM/fzYkCX/NPb9lP
         EIocPxXtk7sUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Zary <linux@zary.sk>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/25] HID: multitouch: Fix Iiyama ProLite T1931SAW (0eef:0001 again!)
Date:   Tue, 30 Nov 2021 09:51:36 -0500
Message-Id: <20211130145156.946083-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Zary <linux@zary.sk>

[ Upstream commit 32bea35746097985c48cec836d5f557a3b66b60a ]

Iiyama ProLite T1931SAW does not work with Linux - input devices are
created but cursor does not move.

It has the infamous 0eef:0001 ID which has been reused for various
devices before.

It seems to require export_all_inputs = true.

Hopefully there are no HID devices using this ID that will break.
It should not break non-HID devices (handled by usbtouchscreen).

Signed-off-by: Ondrej Zary <linux@zary.sk>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 37270b8f4e58b..fe994bfddcd38 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1887,6 +1887,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
 			USB_DEVICE_ID_CVTOUCH_SCREEN) },
 
+	/* eGalax devices (SAW) */
+	{ .driver_data = MT_CLS_EXPORT_ALL_INPUTS,
+		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER) },
+
 	/* eGalax devices (resistive) */
 	{ .driver_data = MT_CLS_EGALAX,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
-- 
2.33.0

