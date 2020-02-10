Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2028157A73
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgBJNWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgBJMhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:18 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D85208C4;
        Mon, 10 Feb 2020 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338238;
        bh=vHsL6AfawnbWeF5SwmkVlWf8ruzCVLjR6inWgxEaI5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peINH94EyrjKFDKkDAxPZY2rOnlM/urtn+pDEhRe2FkP62/Rys6VJfLIjbYbgfBag
         AqQ1Sw8vZhYcDzQwEy70NQuZ50hhA2FO3a8vchg+7VA/5MCxu+fpuKwHQcSnkLXfdg
         QfQVXzOpZ7v1/HZY9GP6zO5kT+7Zsz0ddvbIR6o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 046/309] ALSA: usb-audio: Annotate endianess in Scarlett gen2 quirk
Date:   Mon, 10 Feb 2020 04:30:02 -0800
Message-Id: <20200210122410.466137077@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d8f489355cff55b30731354317739a00cf1238bd upstream.

The Scarlett gen2 mixer quirk code defines a few record types to
communicate via USB hub, and those must be all little-endian.
This patch changes the field types to LE to annotate endianess
properly.  It also fixes the incorrect usage of leXX_to_cpu() in a
couple of places, which was caught by sparse after this change.

Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200201080530.22390-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_scarlett_gen2.c |   46 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -558,11 +558,11 @@ static const struct scarlett2_config
 
 /* proprietary request/response format */
 struct scarlett2_usb_packet {
-	u32 cmd;
-	u16 size;
-	u16 seq;
-	u32 error;
-	u32 pad;
+	__le32 cmd;
+	__le16 size;
+	__le16 seq;
+	__le32 error;
+	__le32 pad;
 	u8 data[];
 };
 
@@ -664,11 +664,11 @@ static int scarlett2_usb(
 			"Scarlett Gen 2 USB invalid response; "
 			   "cmd tx/rx %d/%d seq %d/%d size %d/%d "
 			   "error %d pad %d\n",
-			le16_to_cpu(req->cmd), le16_to_cpu(resp->cmd),
+			le32_to_cpu(req->cmd), le32_to_cpu(resp->cmd),
 			le16_to_cpu(req->seq), le16_to_cpu(resp->seq),
 			resp_size, le16_to_cpu(resp->size),
-			le16_to_cpu(resp->error),
-			le16_to_cpu(resp->pad));
+			le32_to_cpu(resp->error),
+			le32_to_cpu(resp->pad));
 		err = -EINVAL;
 		goto unlock;
 	}
@@ -687,7 +687,7 @@ error:
 /* Send SCARLETT2_USB_DATA_CMD SCARLETT2_USB_CONFIG_SAVE */
 static void scarlett2_config_save(struct usb_mixer_interface *mixer)
 {
-	u32 req = cpu_to_le32(SCARLETT2_USB_CONFIG_SAVE);
+	__le32 req = cpu_to_le32(SCARLETT2_USB_CONFIG_SAVE);
 
 	scarlett2_usb(mixer, SCARLETT2_USB_DATA_CMD,
 		      &req, sizeof(u32),
@@ -713,11 +713,11 @@ static int scarlett2_usb_set_config(
 	const struct scarlett2_config config_item =
 	       scarlett2_config_items[config_item_num];
 	struct {
-		u32 offset;
-		u32 bytes;
-		s32 value;
+		__le32 offset;
+		__le32 bytes;
+		__le32 value;
 	} __packed req;
-	u32 req2;
+	__le32 req2;
 	int err;
 	struct scarlett2_mixer_data *private = mixer->private_data;
 
@@ -753,8 +753,8 @@ static int scarlett2_usb_get(
 	int offset, void *buf, int size)
 {
 	struct {
-		u32 offset;
-		u32 size;
+		__le32 offset;
+		__le32 size;
 	} __packed req;
 
 	req.offset = cpu_to_le32(offset);
@@ -794,8 +794,8 @@ static int scarlett2_usb_set_mix(struct
 	const struct scarlett2_device_info *info = private->info;
 
 	struct {
-		u16 mix_num;
-		u16 data[SCARLETT2_INPUT_MIX_MAX];
+		__le16 mix_num;
+		__le16 data[SCARLETT2_INPUT_MIX_MAX];
 	} __packed req;
 
 	int i, j;
@@ -850,9 +850,9 @@ static int scarlett2_usb_set_mux(struct
 	};
 
 	struct {
-		u16 pad;
-		u16 num;
-		u32 data[SCARLETT2_MUX_MAX];
+		__le16 pad;
+		__le16 num;
+		__le32 data[SCARLETT2_MUX_MAX];
 	} __packed req;
 
 	req.pad = 0;
@@ -911,9 +911,9 @@ static int scarlett2_usb_get_meter_level
 					  u16 *levels)
 {
 	struct {
-		u16 pad;
-		u16 num_meters;
-		u32 magic;
+		__le16 pad;
+		__le16 num_meters;
+		__le32 magic;
 	} __packed req;
 	u32 resp[SCARLETT2_NUM_METERS];
 	int i, err;


