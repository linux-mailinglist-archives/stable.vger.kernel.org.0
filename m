Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC7353E46
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237841AbhDEJFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238130AbhDEJE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8173661393;
        Mon,  5 Apr 2021 09:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613462;
        bh=+rVl4jhU2e9mq9REOVtefD3OfuH0dIJsE4fUJ8fqP5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GizJyJ/LfIFgKmjOr8HpCaOMn0x0bwhQ3f9B09ePsiEE7yUfpnzVHTwQS3g/H1EDG
         k8e8omxB8Fx+L6RWKkIWkXXPc9nqmByttSEyRXX2nD83dHowtgdoNy9dxVaG4FqbxQ
         yoHS0LA0Tmd/CBrgKC0DLwhCYmCHX3Onrlz7M/QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 44/74] ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO
Date:   Mon,  5 Apr 2021 10:54:08 +0200
Message-Id: <20210405085026.163320175@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
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
@@ -5192,7 +5192,7 @@ static void alc_determine_headset_type(s
 	case 0x10ec0274:
 	case 0x10ec0294:
 		alc_process_coef_fw(codec, coef0274);
-		msleep(80);
+		msleep(850);
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x00f0) == 0x00f0;
 		break;


