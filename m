Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B474638DB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244779AbhK3PGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49334 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243194AbhK3O52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65940B817AB;
        Tue, 30 Nov 2021 14:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D8EC53FD0;
        Tue, 30 Nov 2021 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284047;
        bh=HOyL9vV4JsTgx6h6g42FfRV1zEVpHnbAwxrOIY+SJ78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW3dmgsTjkHIurORjlXKgVzhwI0FYQrhEBmEN0tXxlSUNXCxzWyMqftsSelzviqD8
         xcfw98AjC6vyA6dPJGA2ldOUguLQr2xeJ9OfPRsWBOlhHqK2kmEKUiBx+Ja3r6FKis
         8a8hnDBNj/BjXp6atqYuuwgUNnyZNsw5KJ90sfdyBDZc94Zy18oX27mvJIMTRfJ9UP
         Dl+YDnNP/mchvqDevpM+QGSpINccBcwpcRh/TgdqOWDXNx14qJKSrOyS6I4s86dh4o
         Jv5suKGjcp0bjPj/m41Vu4+pHRCTyAVImtG0WwAPPohDNq5U7/VKoC8YJnjH7K82P/
         a0NZFiwBzkiBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Zary <linux@zary.sk>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/9] HID: multitouch: Fix Iiyama ProLite T1931SAW (0eef:0001 again!)
Date:   Tue, 30 Nov 2021 09:53:56 -0500
Message-Id: <20211130145402.947049-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
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
index 5187f3975c655..852df842b9f66 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1245,6 +1245,11 @@ static const struct hid_device_id mt_devices[] = {
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

