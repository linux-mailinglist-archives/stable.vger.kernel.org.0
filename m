Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B01966CB90
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjAPROx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbjAPRNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773294B74E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C20060F61
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF57C433EF;
        Mon, 16 Jan 2023 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888013;
        bh=PcrrV/mHq0jAEVFB9oaJWOJFYz4oh/rDAaeGq0sXkvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdfHt4U9OC26Ldw7zycPWmLVKFM/FobqlL18lyqfRX31mNP9x1FcJLyP2J7A5DTu2
         2av2i0ZEpu0NiEXOU+q36WFRkHDoNYsdYQaGZh4oT87MCtuxFIpnWfocwth5//Xp82
         5Smn8fm06IuU29Z8DkX0F3it81CDrJm1PZl6uvdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Artem Egorkine <arteme@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 368/521] ALSA: line6: correct midi status byte when receiving data from podxt
Date:   Mon, 16 Jan 2023 16:50:30 +0100
Message-Id: <20230116154903.560602941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Artem Egorkine <arteme@gmail.com>

commit 8508fa2e7472f673edbeedf1b1d2b7a6bb898ecc upstream.

A PODxt device sends 0xb2, 0xc2 or 0xf2 as a status byte for MIDI
messages over USB that should otherwise have a 0xb0, 0xc0 or 0xf0
status byte. This is usually corrected by the driver on other OSes.

This fixes MIDI sysex messages sent by PODxt.

[ tiwai: fixed white spaces ]

Signed-off-by: Artem Egorkine <arteme@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221225105728.1153989-1-arteme@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/driver.c  |    3 ++-
 sound/usb/line6/midi.c    |    3 ++-
 sound/usb/line6/midibuf.c |   25 +++++++++++++++++--------
 sound/usb/line6/midibuf.h |    5 ++++-
 sound/usb/line6/pod.c     |    3 ++-
 5 files changed, 27 insertions(+), 12 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -318,7 +318,8 @@ static void line6_data_received(struct u
 		for (;;) {
 			done =
 				line6_midibuf_read(mb, line6->buffer_message,
-						LINE6_MIDI_MESSAGE_MAXLEN);
+						   LINE6_MIDI_MESSAGE_MAXLEN,
+						   LINE6_MIDIBUF_READ_RX);
 
 			if (done <= 0)
 				break;
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -60,7 +60,8 @@ static void line6_midi_transmit(struct s
 
 	for (;;) {
 		done = line6_midibuf_read(mb, chunk,
-					  LINE6_FALLBACK_MAXPACKETSIZE);
+					  LINE6_FALLBACK_MAXPACKETSIZE,
+					  LINE6_MIDIBUF_READ_TX);
 
 		if (done == 0)
 			break;
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -13,6 +13,7 @@
 
 #include "midibuf.h"
 
+
 static int midibuf_message_length(unsigned char code)
 {
 	int message_length;
@@ -24,12 +25,7 @@ static int midibuf_message_length(unsign
 
 		message_length = length[(code >> 4) - 8];
 	} else {
-		/*
-		   Note that according to the MIDI specification 0xf2 is
-		   the "Song Position Pointer", but this is used by Line 6
-		   to send sysex messages to the host.
-		 */
-		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
+		static const int length[] = { -1, 2, 2, 2, -1, -1, 1, 1, 1, -1,
 			1, 1, 1, -1, 1, 1
 		};
 		message_length = length[code & 0x0f];
@@ -129,7 +125,7 @@ int line6_midibuf_write(struct midi_buff
 }
 
 int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
-		       int length)
+		       int length, int read_type)
 {
 	int bytes_used;
 	int length1, length2;
@@ -152,9 +148,22 @@ int line6_midibuf_read(struct midi_buffe
 
 	length1 = this->size - this->pos_read;
 
-	/* check MIDI command length */
 	command = this->buf[this->pos_read];
+	/*
+	   PODxt always has status byte lower nibble set to 0010,
+	   when it means to send 0000, so we correct if here so
+	   that control/program changes come on channel 1 and
+	   sysex message status byte is correct
+	 */
+	if (read_type == LINE6_MIDIBUF_READ_RX) {
+		if (command == 0xb2 || command == 0xc2 || command == 0xf2) {
+			unsigned char fixed = command & 0xf0;
+			this->buf[this->pos_read] = fixed;
+			command = fixed;
+		}
+	}
 
+	/* check MIDI command length */
 	if (command & 0x80) {
 		midi_length = midibuf_message_length(command);
 		this->command_prev = command;
--- a/sound/usb/line6/midibuf.h
+++ b/sound/usb/line6/midibuf.h
@@ -12,6 +12,9 @@
 #ifndef MIDIBUF_H
 #define MIDIBUF_H
 
+#define LINE6_MIDIBUF_READ_TX 0
+#define LINE6_MIDIBUF_READ_RX 1
+
 struct midi_buffer {
 	unsigned char *buf;
 	int size;
@@ -27,7 +30,7 @@ extern void line6_midibuf_destroy(struct
 extern int line6_midibuf_ignore(struct midi_buffer *mb, int length);
 extern int line6_midibuf_init(struct midi_buffer *mb, int size, int split);
 extern int line6_midibuf_read(struct midi_buffer *mb, unsigned char *data,
-			      int length);
+			      int length, int read_type);
 extern void line6_midibuf_reset(struct midi_buffer *mb);
 extern int line6_midibuf_write(struct midi_buffer *mb, unsigned char *data,
 			       int length);
--- a/sound/usb/line6/pod.c
+++ b/sound/usb/line6/pod.c
@@ -169,8 +169,9 @@ static struct line6_pcm_properties pod_p
 	.bytes_per_channel = 3 /* SNDRV_PCM_FMTBIT_S24_3LE */
 };
 
+
 static const char pod_version_header[] = {
-	0xf2, 0x7e, 0x7f, 0x06, 0x02
+	0xf0, 0x7e, 0x7f, 0x06, 0x02
 };
 
 /* forward declarations: */


