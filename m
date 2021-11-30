Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73124638B0
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243895AbhK3PFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244276AbhK3PAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:00:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD0C08E8A7;
        Tue, 30 Nov 2021 06:52:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA94CCE1A5F;
        Tue, 30 Nov 2021 14:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3183DC53FCD;
        Tue, 30 Nov 2021 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283975;
        bh=tKzAu06Dd72ohPG97XHXWUR0l0lQ4r2kTYZclIIhQxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=es9mU3sSha+96JvfC0aisMKtwA/3gDr5rwsL9YjLq2zi7fGgUEPIu7j4S7oYK+5e9
         chd4c7rSztmkXdjdR0cfNy5zpMFQDnIY8qFsBjBLLYdemH0gI9tUzgKbj2/l7BZIMc
         MvmEhGjPeW4c9LRkJRSGjQySG9KKRCkGnJcCMyIOoHnLQcR9lArEKaEsqkrNft522P
         NIorJ8DS8moSLHsKHCLxGZmPYTFKgszA65QgSadAFNs415t19Emp4CMLifjtPkn/ex
         Hzt32wsSZdd/RU7xG8226b9Z1n/w0NqoOxd8Grhi7UIyPq2ABIKwRCUp+e5QCQeSld
         HDP6RM0k+nEEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Zary <linux@zary.sk>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/17] HID: multitouch: Fix Iiyama ProLite T1931SAW (0eef:0001 again!)
Date:   Tue, 30 Nov 2021 09:52:30 -0500
Message-Id: <20211130145243.946407-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index c20945ed1dc19..d0fa421a38573 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1858,6 +1858,11 @@ static const struct hid_device_id mt_devices[] = {
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

