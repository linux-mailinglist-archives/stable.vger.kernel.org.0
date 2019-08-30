Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F02A3FE9
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 23:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfH3VrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 17:47:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37585 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3VrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Aug 2019 17:47:17 -0400
Received: by mail-io1-f66.google.com with SMTP id r4so1807495iop.4;
        Fri, 30 Aug 2019 14:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zobn1PfaWdiFKh+2AJisvXaXaN9Pv4+pvGnHv+s5H4g=;
        b=PqoH0U6MfwrpAsH2I8tyCEQptXVIiBeTnOsXbU8Ar8ranL1XpLus6OwSuKVJ3vvw1t
         NyOIEgheKhfIOyWmzehIPpcCMBCbnVBmqAVaIYK8uOQz9qbtKYu743+vuP5K3vLLB86u
         92/oafOaYMZXZ6I/YRq9y0ful6k7Y4g0CFxQwnrPo4oQFzD45FVBN0X23i9z6JCYEP4v
         0AGR2TKK1ckUBolAcqZvVz2e/uzlYquJb61tIlX7sV6wqla4vfB8rVCR9x432k+17SsJ
         cTIu4QtXSiaGkEKed2pxOdm30n1pukvCPAAew81YizAWchrT7FrirRpuA84mqm1+0Jyw
         fDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zobn1PfaWdiFKh+2AJisvXaXaN9Pv4+pvGnHv+s5H4g=;
        b=QLRyj++d9O9UP47p/4OFHiKpcUMkPLJcWwKpKHUlg9H/hRw37mdcqVzgxy6v5bcnXG
         Y4aIwtX76XzT3fePR0Asr8XAmjhe7q7oFFHvjmPmzSoZjN7rD+vScYoUAnDrxF3eACoY
         ncuvEpjLKBTVzT7gweiBy+qtYc7PvwY1493DTiz8epK0amItFnCMeg2FzJP267d7ZhHt
         Tc5W0f034aYeDZjq9TAvJVDrxfrWUpsQJ8Hc6ZxfhrcBn2Cuiw9uUDGOqEgspAZmbBv8
         pvgqa3MNZctjv/i3pPgxs7LCqGFl5WJASBMLdb9pBjJipD1yT0HsgvyCRGmM13pfvvkf
         QM+A==
X-Gm-Message-State: APjAAAVH0zCaRGdvwaPtQ5OVdoRgA95qXzcxF4JGcxO4C+/5Mh5JRuPb
        suzo/DQ7u4uHNzdm4sBUkg8cOkeVm/kWeA==
X-Google-Smtp-Source: APXvYqzDz5V/Q5AiD+cZ2p5/0vLITIFai9ECVqT6mDBjH8GdVUW+FMbMKnbyxabOxzlGVMoewVzgcA==
X-Received: by 2002:a02:c992:: with SMTP id b18mr18578961jap.128.1567201636655;
        Fri, 30 Aug 2019 14:47:16 -0700 (PDT)
Received: from peng.science.purdue.edu (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.googlemail.com with ESMTPSA id m10sm5951564ioj.75.2019.08.30.14.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 14:47:16 -0700 (PDT)
From:   Hui Peng <benquike@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wenwen Wang <wang6495@umn.edu>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fix an OOB bug in parse_audio_mixer_unit
Date:   Fri, 30 Aug 2019 17:46:49 -0400
Message-Id: <20190830214649.27761-1-benquike@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

CVE: CVE-2018-15117

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 1f7eb3816cd7..10ddec76f906 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1628,6 +1628,7 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 	int pin, ich, err;
 
 	if (desc->bLength < 11 || !(input_pins = desc->bNrInPins) ||
+	    desc->bLength < sizeof(*desc) + desc->bNrInPins ||
 	    !(num_outs = uac_mixer_unit_bNrChannels(desc))) {
 		usb_audio_err(state->chip,
 			      "invalid MIXER UNIT descriptor %d\n",
-- 
2.17.1

