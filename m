Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D31353EE2
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238572AbhDEJIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238606AbhDEJI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885D6613A0;
        Mon,  5 Apr 2021 09:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613702;
        bh=3y6gV7abTaiMEVM0s/CrvK3mwG9M62wV1EKPJAHJzK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsAhaBVrwlBowQOESBDVNn0U4RsZ/8fspJMc2POJ9ESpzy38OZzjgB6LstIiYTWqa
         0n1vn7P3tsHW7vBiFGbz8xZDPtRgUq27oteu2qscsN5NJPkcTEwNGXAlkk90gH+IB0
         1kcTBS3XmjIrDIDizzNXas9mY/Ct6EyYbHVSdU+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 060/126] ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO
Date:   Mon,  5 Apr 2021 10:53:42 +0200
Message-Id: <20210405085033.036763839@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit febf22565549ea7111e7d45e8f2d64373cc66b11 upstream.

We found a recording issue on a Dell AIO, users plug a headset-mic and
select headset-mic from UI, but can't record any sound from
headset-mic. The root cause is the determine_headset_type() returns a
wrong type, e.g. users plug a ctia type headset, but that function
returns omtp type.

On this machine, the internal mic is not connected to the codec, the
"Input Source" is headset mic by default. And when users plug a
headset, the determine_headset_type() will be called immediately, the
codec on this AIO is alc274, the delay time for this codec in the
determine_headset_type() is only 80ms, the delay is too short to
correctly determine the headset type, the fail rate is nearly 99% when
users plug the headset with the normal speed.

Other codecs set several hundred ms delay time, so here I change the
delay time to 850ms for alc2x4 series, after this change, the fail
rate is zero unless users plug the headset slowly on purpose.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210320091542.6748-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5256,7 +5256,7 @@ static void alc_determine_headset_type(s
 	case 0x10ec0274:
 	case 0x10ec0294:
 		alc_process_coef_fw(codec, coef0274);
-		msleep(80);
+		msleep(850);
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x00f0) == 0x00f0;
 		break;


