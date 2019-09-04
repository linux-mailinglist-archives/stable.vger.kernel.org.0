Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF0CA8F4B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbfIDSCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388834AbfIDSCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3569D208E4;
        Wed,  4 Sep 2019 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620171;
        bh=xTGWqD+CPd4N1bD61EJqVR8BBD+YzMgcGg8fM/4Yz9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyW652LaPfnGaF/blQFZK73zjP5FkcqzIxCGhjFJrpccuEqwk3UqnIGIYVYBOcGrt
         /nlWf65p1CCThXwJ+/Kd/HUg4P5tO4qBLE9hh3gqu2XdQ2AZp+HKNOAGsBX66AyZhy
         FVK9AwOjiFK/4NPzJwnNRkfGG9SRdgP40F380ER4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 17/57] ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
Date:   Wed,  4 Sep 2019 19:53:45 +0200
Message-Id: <20190904175303.653360419@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Peng <benquike@gmail.com>

commit 19bce474c45be69a284ecee660aa12d8f1e88f18 upstream.

`check_input_term` recursively calls itself with input from
device side (e.g., uac_input_terminal_descriptor.bCSourceID)
as argument (id). In `check_input_term`, if `check_input_term`
is called with the same `id` argument as the caller, it triggers
endless recursive call, resulting kernel space stack overflow.

This patch fixes the bug by adding a bitmap to `struct mixer_build`
to keep track of the checked ids and stop the execution if some id
has been checked (similar to how parse_audio_unit handles unitid
argument).

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 sound/usb/mixer.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -82,6 +82,7 @@ struct mixer_build {
 	unsigned char *buffer;
 	unsigned int buflen;
 	DECLARE_BITMAP(unitbitmap, MAX_ID_ELEMS);
+	DECLARE_BITMAP(termbitmap, MAX_ID_ELEMS);
 	struct usb_audio_term oterm;
 	const struct usbmix_name_map *map;
 	const struct usbmix_selector_map *selector_map;
@@ -716,15 +717,24 @@ static int get_term_name(struct mixer_bu
  * parse the source unit recursively until it reaches to a terminal
  * or a branched unit.
  */
-static int check_input_term(struct mixer_build *state, int id,
+static int __check_input_term(struct mixer_build *state, int id,
 			    struct usb_audio_term *term)
 {
 	int err;
 	void *p1;
+	unsigned char *hdr;
 
 	memset(term, 0, sizeof(*term));
-	while ((p1 = find_audio_control_unit(state, id)) != NULL) {
-		unsigned char *hdr = p1;
+	for (;;) {
+		/* a loop in the terminal chain? */
+		if (test_and_set_bit(id, state->termbitmap))
+			return -EINVAL;
+
+		p1 = find_audio_control_unit(state, id);
+		if (!p1)
+			break;
+
+		hdr = p1;
 		term->id = id;
 		switch (hdr[2]) {
 		case UAC_INPUT_TERMINAL:
@@ -739,7 +749,7 @@ static int check_input_term(struct mixer
 
 				/* call recursively to verify that the
 				 * referenced clock entity is valid */
-				err = check_input_term(state, d->bCSourceID, term);
+				err = __check_input_term(state, d->bCSourceID, term);
 				if (err < 0)
 					return err;
 
@@ -771,7 +781,7 @@ static int check_input_term(struct mixer
 		case UAC2_CLOCK_SELECTOR: {
 			struct uac_selector_unit_descriptor *d = p1;
 			/* call recursively to retrieve the channel info */
-			err = check_input_term(state, d->baSourceID[0], term);
+			err = __check_input_term(state, d->baSourceID[0], term);
 			if (err < 0)
 				return err;
 			term->type = d->bDescriptorSubtype << 16; /* virtual type */
@@ -818,6 +828,15 @@ static int check_input_term(struct mixer
 	return -ENODEV;
 }
 
+
+static int check_input_term(struct mixer_build *state, int id,
+			    struct usb_audio_term *term)
+{
+	memset(term, 0, sizeof(*term));
+	memset(state->termbitmap, 0, sizeof(state->termbitmap));
+	return __check_input_term(state, id, term);
+}
+
 /*
  * Feature Unit
  */


