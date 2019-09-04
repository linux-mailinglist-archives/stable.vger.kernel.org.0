Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5057CA8E69
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbfIDR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbfIDR5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:57:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D53208E4;
        Wed,  4 Sep 2019 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619871;
        bh=Lkez0H8g512vv4Kuq61c+tVEtrjq9LRaNj4FxuXnCEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUXOyB+b9gi7roU8Oy3vzzAKswaBj8bSD/l1zjcw5vAQMqCw+hR/c0Zhlwo/6+i6X
         XPTL7JAyk4z5SWrcO1eRcYdDc/PCT5qCHtI+QzdTJaVV1Lj0AtfqsE0LmN3ZsiLxBd
         H36M0zfsgHhHZ0S+DQw+0BbEV8VFe8V9xH0Uu31k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 58/77] ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit
Date:   Wed,  4 Sep 2019 19:53:45 +0200
Message-Id: <20190904175308.742764660@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
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
 sound/usb/mixer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1647,6 +1647,7 @@ static int parse_audio_mixer_unit(struct
 	int pin, ich, err;
 
 	if (desc->bLength < 11 || !(input_pins = desc->bNrInPins) ||
+	    desc->bLength < sizeof(*desc) + desc->bNrInPins ||
 	    !(num_outs = uac_mixer_unit_bNrChannels(desc))) {
 		usb_audio_err(state->chip,
 			      "invalid MIXER UNIT descriptor %d\n",


