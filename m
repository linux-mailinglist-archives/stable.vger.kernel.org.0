Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0800F667725
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239747AbjALOkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbjALOjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:39:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4944E50156
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:29:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9DC9CE1E5F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C64C433D2;
        Thu, 12 Jan 2023 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533757;
        bh=veC60ZZIxlv7xmN1vv6FVX95uUYCp0YvFsG6iTaE4ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVEBXkPhLYdTOC5edpX0g2Eck2miMt2VVB0pRTS6p/x64aOddEnb0JtSv9sF1ThuS
         KtTB+Dq/0C+5gSdGQwiNp9vyM+suKDrlw4v95u05Ucmk+r6ZZOv0kTfnho6YvwcM7I
         v/1ks9cY4zBqxo0auH2Z2FcjRUK6KiTnw6r4eVLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akito <the@akito.ooo>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 583/783] HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint
Date:   Thu, 12 Jan 2023 14:54:59 +0100
Message-Id: <20230112135551.286383608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 4eab1c2fe06c98a4dff258dd64800b6986c101e9 ]

The HID descriptor of this device contains two mouse collections, one
for mouse emulation and the other for the trackpoint.

Both collections get merged and, because the first one defines X and Y,
the movemenent events reported by the trackpoint collection are
ignored.

Set the MT_CLS_WIN_8_FORCE_MULTI_INPUT class for this device to be able
to receive its reports.

This fix is similar to/based on commit 40d5bb87377a ("HID: multitouch:
enable multi-input as a quirk for some devices").

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/825
Reported-by: Akito <the@akito.ooo>
Tested-by: Akito <the@akito.ooo>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index a78ce16d4782..ea8c52f0aa78 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1912,6 +1912,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x313a) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x3148) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
-- 
2.35.1



