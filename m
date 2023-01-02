Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3565B0A7
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjABL1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjABL0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFCD65DC
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:25:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BFA160F49
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C632C433F1;
        Mon,  2 Jan 2023 11:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658711;
        bh=AbnPlA2rxyD6/fEDBrUH2gyFaqCrUGv4i5hDuU+QrME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pq8EgNKTf2Uu1YWAfo0h2Sa3umoIWmAdDjdJfg/N+DBTfJg4O1Qfj2MS9Btuw0wvW
         s9fBZR1HCo4yen8fUcycxQnrVH0e+btqJ1rswn1qyLOuvMFmnTeNSSR1MIhN1dxp0f
         77Y/qr8fkJIRmnbrw+vq5XKJrwIoC2h871qbwz/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akito <the@akito.ooo>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/71] HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint
Date:   Mon,  2 Jan 2023 12:22:05 +0100
Message-Id: <20230102110553.148001529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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
index 91a4d3fc30e0..372cbdd223e0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1967,6 +1967,10 @@ static const struct hid_device_id mt_devices[] = {
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



