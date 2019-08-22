Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6C499C5B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392351AbfHVRdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404412AbfHVRZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:25 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2844A2064A;
        Thu, 22 Aug 2019 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494724;
        bh=DTcBYyr8NGbTdWPT9hVXwPCximMsjizRF2mTgYqENgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDRg1dApxXnWUDGRimNL1HpOk1B0Xqx3wyWHIF8XIE3aV3ek+AjTzZne6pvTFCKLm
         CUgppKyB5KG3vN45cF8WDUl+ykAsZfqcbo7ygJh5SPPWYp2ldF8h8+vCcKLvjySz3r
         dP27fXslFwS2hCj1n3OyibK+i41+5W/YmFohqSuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 13/85] ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit
Date:   Thu, 22 Aug 2019 10:18:46 -0700
Message-Id: <20190822171731.662885183@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -760,6 +760,8 @@ static int uac_mixer_unit_get_channels(s
 		return -EINVAL;
 	if (!desc->bNrInPins)
 		return -EINVAL;
+	if (desc->bLength < sizeof(*desc) + desc->bNrInPins)
+		return -EINVAL;
 
 	switch (state->mixer->protocol) {
 	case UAC_VERSION_1:


