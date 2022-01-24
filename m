Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE449A3EC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369162AbiAYABI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847008AbiAXXSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22224C0604EC;
        Mon, 24 Jan 2022 13:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDFF7B81188;
        Mon, 24 Jan 2022 21:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D95C340E4;
        Mon, 24 Jan 2022 21:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059545;
        bh=HoRFq8w8CiMPBLb0x+C92QMyIan+0WTQQNaMjjijmKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egiejmGqv6lDbrE0N1VTrRoQ1eiGTcQAb91Oxj4bUm0dUGZEXBPzz1wru+zZo5a76
         koywyaFu6iTxTUOd7X/7Vcd8BOcckoAfcASWzEbSWmxexmBcnoniBwKWin3dPNL6Ts
         Azv+zUfwVCPL4zZ1Pw9anBKcxBlEls/HdDLxx0H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0650/1039] HID: quirks: Allow inverting the absolute X/Y values
Date:   Mon, 24 Jan 2022 19:40:39 +0100
Message-Id: <20220124184147.211834175@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Francis <alistair@alistair23.me>

[ Upstream commit fd8d135b2c5e88662f2729e034913f183455a667 ]

Add a HID_QUIRK_X_INVERT/HID_QUIRK_Y_INVERT quirk that can be used
to invert the X/Y values.

Signed-off-by: Alistair Francis <alistair@alistair23.me>
[bentiss: silence checkpatch warning]
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211208124045.61815-2-alistair@alistair23.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 6 ++++++
 include/linux/hid.h     | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index ca47682cc7307..87fee137ff65e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1335,6 +1335,12 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 
 	input = field->hidinput->input;
 
+	if (usage->type == EV_ABS &&
+	    (((*quirks & HID_QUIRK_X_INVERT) && usage->code == ABS_X) ||
+	     ((*quirks & HID_QUIRK_Y_INVERT) && usage->code == ABS_Y))) {
+		value = field->logical_maximum - value;
+	}
+
 	if (usage->hat_min < usage->hat_max || usage->hat_dir) {
 		int hat_dir = usage->hat_dir;
 		if (!hat_dir)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index f453be385bd47..26742ca14609a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -349,6 +349,8 @@ struct hid_item {
 /* BIT(9) reserved for backward compatibility, was NO_INIT_INPUT_REPORTS */
 #define HID_QUIRK_ALWAYS_POLL			BIT(10)
 #define HID_QUIRK_INPUT_PER_APP			BIT(11)
+#define HID_QUIRK_X_INVERT			BIT(12)
+#define HID_QUIRK_Y_INVERT			BIT(13)
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		BIT(16)
 #define HID_QUIRK_SKIP_OUTPUT_REPORT_ID		BIT(17)
 #define HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP	BIT(18)
-- 
2.34.1



