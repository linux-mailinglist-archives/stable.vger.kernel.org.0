Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA1E655C5
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfGKLdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:33:11 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38133 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728026AbfGKLdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:33:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8B55043F;
        Thu, 11 Jul 2019 07:33:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=awbq69
        8EYJ5WkIYtu7wbuOaajdzLA3auFsNL2b1m7no=; b=LfmELgyj+YSAnyjHua/cFT
        bBrqYdzSbh4wLiTx7tD6ROCKMN1Qc/fvoO3goeQW5aDPhClUUuxpWR0yZu7o/nWI
        lxgND0vvXZgBIFycgepWm/GfhPEetZp+YW+8mQ6xsvXil8FFrI5mNMy5KNua+eQd
        mEpYuZTZtUtNSQfBzDR4+5v7vtJxl2Q7juXmG8Z6Rz7eqKubZEmtHD2/g6rmMpci
        OLU3WlCUhltB/BEPVnhKoU22AH8KG8fYh70srcPNXFRYrhl7P10NO0v+y8/brIwO
        diQA6Ug19lNlyQjP3yzxmpILs3cHgqhjh/5vVFmBxvDpe/cmetHWigPaAVDBJQVA
        ==
X-ME-Sender: <xms:dB4nXSoN4FyIJ0YYiJGXAQsUzlpWFK57odF9z-mm6Fq-nT8S5PvdAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:dB4nXYcSQoSXVbt5heUXC35lv4a31le5D2Vy6qgSPUAp857AWt4csQ>
    <xmx:dB4nXSnGfz3U4sNj2Hj8WCWSPc0lGiDZAsCpiGk99fi5oQLM1XdlqQ>
    <xmx:dB4nXbuNAGJLpZz54xqHvk0T45ssAgan8M9hax7hpzEcdPesvoD3Zg>
    <xmx:dR4nXYpY7760I5P0tVIl626fOqbTdJj2Dj-FWD4hSjjvvblQjbCZJw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A4E380063;
        Thu, 11 Jul 2019 07:33:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Fix parse of UAC2 Extension Units" failed to apply to 4.14-stable tree
To:     tiwai@suse.de, ensonic@hora-obscura.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:33:06 +0200
Message-ID: <156284478614593@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca95c7bf3d29716916baccdc77c3c2284b703069 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Thu, 4 Jul 2019 16:31:12 +0200
Subject: [PATCH] ALSA: usb-audio: Fix parse of UAC2 Extension Units

Extension Unit (XU) is used to have a compatible layout with
Processing Unit (PU) on UAC1, and the usb-audio driver code assumed it
for parsing the descriptors.  Meanwhile, on UAC2, XU became slightly
incompatible with PU; namely, XU has a one-byte bmControls bitmap
while PU has two bytes bmControls bitmap.  This incompatibility
results in the read of a wrong address for the last iExtension field,
which ended up with an incorrect string for the mixer element name, as
recently reported for Focusrite Scarlett 18i20 device.

This patch corrects this misalignment by introducing a couple of new
macros and calling them depending on the descriptor type.

Fixes: 23caaf19b11e ("ALSA: usb-mixer: Add support for Audio Class v2.0")
Reported-by: Stefan Sauer <ensonic@hora-obscura.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/include/uapi/linux/usb/audio.h b/include/uapi/linux/usb/audio.h
index ddc5396800aa..76b7c3f6cd0d 100644
--- a/include/uapi/linux/usb/audio.h
+++ b/include/uapi/linux/usb/audio.h
@@ -450,6 +450,43 @@ static inline __u8 *uac_processing_unit_specific(struct uac_processing_unit_desc
 	}
 }
 
+/*
+ * Extension Unit (XU) has almost compatible layout with Processing Unit, but
+ * on UAC2, it has a different bmControls size (bControlSize); it's 1 byte for
+ * XU while 2 bytes for PU.  The last iExtension field is a one-byte index as
+ * well as iProcessing field of PU.
+ */
+static inline __u8 uac_extension_unit_bControlSize(struct uac_processing_unit_descriptor *desc,
+						   int protocol)
+{
+	switch (protocol) {
+	case UAC_VERSION_1:
+		return desc->baSourceID[desc->bNrInPins + 4];
+	case UAC_VERSION_2:
+		return 1; /* in UAC2, this value is constant */
+	case UAC_VERSION_3:
+		return 4; /* in UAC3, this value is constant */
+	default:
+		return 1;
+	}
+}
+
+static inline __u8 uac_extension_unit_iExtension(struct uac_processing_unit_descriptor *desc,
+						 int protocol)
+{
+	__u8 control_size = uac_extension_unit_bControlSize(desc, protocol);
+
+	switch (protocol) {
+	case UAC_VERSION_1:
+	case UAC_VERSION_2:
+	default:
+		return *(uac_processing_unit_bmControls(desc, protocol)
+			 + control_size);
+	case UAC_VERSION_3:
+		return 0; /* UAC3 does not have this field */
+	}
+}
+
 /* 4.5.2 Class-Specific AS Interface Descriptor */
 struct uac1_as_header_descriptor {
 	__u8  bLength;			/* in bytes: 7 */
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index e003b5e7b01a..ac121b10c51c 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2318,7 +2318,7 @@ static struct procunit_info extunits[] = {
  */
 static int build_audio_procunit(struct mixer_build *state, int unitid,
 				void *raw_desc, struct procunit_info *list,
-				char *name)
+				bool extension_unit)
 {
 	struct uac_processing_unit_descriptor *desc = raw_desc;
 	int num_ins;
@@ -2335,6 +2335,8 @@ static int build_audio_procunit(struct mixer_build *state, int unitid,
 	static struct procunit_info default_info = {
 		0, NULL, default_value_info
 	};
+	const char *name = extension_unit ?
+		"Extension Unit" : "Processing Unit";
 
 	if (desc->bLength < 13) {
 		usb_audio_err(state->chip, "invalid %s descriptor (id %d)\n", name, unitid);
@@ -2448,7 +2450,10 @@ static int build_audio_procunit(struct mixer_build *state, int unitid,
 		} else if (info->name) {
 			strlcpy(kctl->id.name, info->name, sizeof(kctl->id.name));
 		} else {
-			nameid = uac_processing_unit_iProcessing(desc, state->mixer->protocol);
+			if (extension_unit)
+				nameid = uac_extension_unit_iExtension(desc, state->mixer->protocol);
+			else
+				nameid = uac_processing_unit_iProcessing(desc, state->mixer->protocol);
 			len = 0;
 			if (nameid)
 				len = snd_usb_copy_string_desc(state->chip,
@@ -2481,10 +2486,10 @@ static int parse_audio_processing_unit(struct mixer_build *state, int unitid,
 	case UAC_VERSION_2:
 	default:
 		return build_audio_procunit(state, unitid, raw_desc,
-				procunits, "Processing Unit");
+					    procunits, false);
 	case UAC_VERSION_3:
 		return build_audio_procunit(state, unitid, raw_desc,
-				uac3_procunits, "Processing Unit");
+					    uac3_procunits, false);
 	}
 }
 
@@ -2495,8 +2500,7 @@ static int parse_audio_extension_unit(struct mixer_build *state, int unitid,
 	 * Note that we parse extension units with processing unit descriptors.
 	 * That's ok as the layout is the same.
 	 */
-	return build_audio_procunit(state, unitid, raw_desc,
-				    extunits, "Extension Unit");
+	return build_audio_procunit(state, unitid, raw_desc, extunits, true);
 }
 
 /*

