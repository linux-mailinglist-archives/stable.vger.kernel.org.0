Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA37C4638E1
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbhK3PGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243510AbhK3O4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA802C0698C1;
        Tue, 30 Nov 2021 06:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94606B81A4D;
        Tue, 30 Nov 2021 14:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C493C53FD1;
        Tue, 30 Nov 2021 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283862;
        bh=jG04/GIRk/SCkFli3pFrAuZURh04n6uUKX+i9hJgAn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mh10EYDITiZyGMkTdtqAZT9MuluEXHPwGogyWoKXjO4cKYby8b9TuXAG3yKos9Kwl
         4LRu3Aumrurmh7gzSyMJ+hHCcZ39OOvrPNqgSaLdAWU2wIRWffjIodLkTj92yaY7Ah
         I9zzVYF+O15x4OzAEuQ0lVZGAG0K6EhRRjdzjBZ9F9qDx0oivAX7rLyfUhqrQW31UJ
         tNjOLS0jwDKJFMVCUgGAa3dywDN/S9uf00F4WgS8JcXyWEEykyKqEv2S/D+i3IU8GT
         izIRBU6aPOtdQN8f1As11kxSe99DtQ+ayx9yzyQiDrf3nW+E2W+TuyJZY6OYo6VTII
         GrF7RfhJBFQbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Zary <linux@zary.sk>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/43] HID: multitouch: Fix Iiyama ProLite T1931SAW (0eef:0001 again!)
Date:   Tue, 30 Nov 2021 09:49:53 -0500
Message-Id: <20211130145022.945517-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index e5a3704b9fe8f..1c9c4523691e7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1846,6 +1846,11 @@ static const struct hid_device_id mt_devices[] = {
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

