Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D01C17EF
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfI2Rek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbfI2Rej (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7AB21D71;
        Sun, 29 Sep 2019 17:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778478;
        bh=QPtqNeyMsNf02U0gseQ4oTIdZSRz1mT4OcfhwZov/V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1J2GpyOil9hXmxGva4HHAU3Kd+3g6QP75Ng6RQKTD4iEAWl0wLWylLwqOeA1rEv2
         W3Or8ZjlMcacwwr4rj2qdmXah4QM2SKpbP2Ml2i9yCNBPfxS7o/qByG/r2maWmnZDH
         2DjBlxSQAu6CzS6vi2Aw/skQ163OZiRT4fmh+knM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gerecke <killertofu@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/33] HID: wacom: Fix several minor compiler warnings
Date:   Sun, 29 Sep 2019 13:33:55 -0400
Message-Id: <20190929173424.9361-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

[ Upstream commit 073b50bccbbf99a3b79a1913604c656d0e1a56c9 ]

Addresses a few issues that were noticed when compiling with non-default
warnings enabled. The trimmed-down warnings in the order they are fixed
below are:

* declaration of 'size' shadows a parameter

* '%s' directive output may be truncated writing up to 5 bytes into a
  region of size between 1 and 64

* pointer targets in initialization of 'char *' from 'unsigned char *'
  differ in signedness

* left shift of negative value

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_sys.c | 7 ++++---
 drivers/hid/wacom_wac.c | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 5a2d5140c1f42..3038c975e417c 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -91,7 +91,7 @@ static void wacom_wac_queue_flush(struct hid_device *hdev,
 }
 
 static int wacom_wac_pen_serial_enforce(struct hid_device *hdev,
-		struct hid_report *report, u8 *raw_data, int size)
+		struct hid_report *report, u8 *raw_data, int report_size)
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
@@ -152,7 +152,8 @@ static int wacom_wac_pen_serial_enforce(struct hid_device *hdev,
 	if (flush)
 		wacom_wac_queue_flush(hdev, &wacom_wac->pen_fifo);
 	else if (insert)
-		wacom_wac_queue_insert(hdev, &wacom_wac->pen_fifo, raw_data, size);
+		wacom_wac_queue_insert(hdev, &wacom_wac->pen_fifo,
+				       raw_data, report_size);
 
 	return insert && !flush;
 }
@@ -2147,7 +2148,7 @@ static void wacom_update_name(struct wacom *wacom, const char *suffix)
 {
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
 	struct wacom_features *features = &wacom_wac->features;
-	char name[WACOM_NAME_MAX];
+	char name[WACOM_NAME_MAX - 20]; /* Leave some room for suffixes */
 
 	/* Generic devices name unspecified */
 	if ((features->type == HID_GENERIC) && !strcmp("Wacom HID", features->name)) {
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 6f5c838f9d474..1df037e7f0b42 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -255,7 +255,7 @@ static int wacom_dtu_irq(struct wacom_wac *wacom)
 
 static int wacom_dtus_irq(struct wacom_wac *wacom)
 {
-	char *data = wacom->data;
+	unsigned char *data = wacom->data;
 	struct input_dev *input = wacom->pen_input;
 	unsigned short prox, pressure = 0;
 
@@ -576,7 +576,7 @@ static int wacom_intuos_pad(struct wacom_wac *wacom)
 		strip2 = ((data[3] & 0x1f) << 8) | data[4];
 	}
 
-	prox = (buttons & ~(~0 << nbuttons)) | (keys & ~(~0 << nkeys)) |
+	prox = (buttons & ~(~0U << nbuttons)) | (keys & ~(~0U << nkeys)) |
 	       (ring1 & 0x80) | (ring2 & 0x80) | strip1 | strip2;
 
 	wacom_report_numbered_buttons(input, nbuttons, buttons);
-- 
2.20.1

