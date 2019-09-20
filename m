Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7898B92B7
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388185AbfITOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36114 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388144AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-00051H-Ug; Fri, 20 Sep 2019 15:25:02 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007yJ-87; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hui Peng" <benquike@gmail.com>, "Takashi Iwai" <tiwai@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mathias Payer" <mathias.payer@nebelwelt.net>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.695753136@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 113/132] ALSA: usb-audio: Fix an OOB bug in
 parse_audio_mixer_unit
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit daac07156b330b18eb5071aec4b3ddca1c377f2c upstream.

The `uac_mixer_unit_descriptor` shown as below is read from the
device side. In `parse_audio_mixer_unit`, `baSourceID` field is
accessed from index 0 to `bNrInPins` - 1, the current implementation
assumes that descriptor is always valid (the length  of descriptor
is no shorter than 5 + `bNrInPins`). If a descriptor read from
the device side is invalid, it may trigger out-of-bound memory
access.

```
struct uac_mixer_unit_descriptor {
	__u8 bLength;
	__u8 bDescriptorType;
	__u8 bDescriptorSubtype;
	__u8 bUnitID;
	__u8 bNrInPins;
	__u8 baSourceID[];
}
```

This patch fixes the bug by add a sanity check on the length of
the descriptor.

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1594,6 +1594,7 @@ static int parse_audio_mixer_unit(struct
 	int pin, ich, err;
 
 	if (desc->bLength < 11 || !(input_pins = desc->bNrInPins) ||
+	    desc->bLength < sizeof(*desc) + desc->bNrInPins ||
 	    !(num_outs = uac_mixer_unit_bNrChannels(desc))) {
 		usb_audio_err(state->chip,
 			      "invalid MIXER UNIT descriptor %d\n",

