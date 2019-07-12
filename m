Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF866CBD
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfGLMWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbfGLMWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:22:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD362216B7;
        Fri, 12 Jul 2019 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934169;
        bh=2FpaDrEkkU/OejyQ1varbZjE+hpLbG/ApQ22rKgnvig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoKQwA2yORos0AbcdKrPfjSAuZnE/K3KP4nouxh0Q5HULVrht0AwJxeVO/X8JDjWy
         P1zG/5qlJ0+KIS2EPqUceiRwXSw8yi4wuw40WgDiWAEln+nkTfcpsvQW/FVgL1vP/r
         JdOzymsWmrGdn9Efke2oAHMVQn09Tvqm4iEJkv9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Sauer <ensonic@hora-obscura.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 59/91] ALSA: usb-audio: Fix parse of UAC2 Extension Units
Date:   Fri, 12 Jul 2019 14:19:02 +0200
Message-Id: <20190712121624.909362477@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ca95c7bf3d29716916baccdc77c3c2284b703069 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/usb/audio.h |   37 +++++++++++++++++++++++++++++++++++++
 sound/usb/mixer.c              |   16 ++++++++++------
 2 files changed, 47 insertions(+), 6 deletions(-)

--- a/include/uapi/linux/usb/audio.h
+++ b/include/uapi/linux/usb/audio.h
@@ -450,6 +450,43 @@ static inline __u8 *uac_processing_unit_
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
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2322,7 +2322,7 @@ static struct procunit_info extunits[] =
  */
 static int build_audio_procunit(struct mixer_build *state, int unitid,
 				void *raw_desc, struct procunit_info *list,
-				char *name)
+				bool extension_unit)
 {
 	struct uac_processing_unit_descriptor *desc = raw_desc;
 	int num_ins;
@@ -2339,6 +2339,8 @@ static int build_audio_procunit(struct m
 	static struct procunit_info default_info = {
 		0, NULL, default_value_info
 	};
+	const char *name = extension_unit ?
+		"Extension Unit" : "Processing Unit";
 
 	if (desc->bLength < 13) {
 		usb_audio_err(state->chip, "invalid %s descriptor (id %d)\n", name, unitid);
@@ -2452,7 +2454,10 @@ static int build_audio_procunit(struct m
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
@@ -2485,10 +2490,10 @@ static int parse_audio_processing_unit(s
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
 
@@ -2499,8 +2504,7 @@ static int parse_audio_extension_unit(st
 	 * Note that we parse extension units with processing unit descriptors.
 	 * That's ok as the layout is the same.
 	 */
-	return build_audio_procunit(state, unitid, raw_desc,
-				    extunits, "Extension Unit");
+	return build_audio_procunit(state, unitid, raw_desc, extunits, true);
 }
 
 /*


