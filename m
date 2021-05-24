Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87738EFBC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhEXP7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235280AbhEXP6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 955C961966;
        Mon, 24 May 2021 15:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871066;
        bh=aoE07AxbEXXT3P9Md44PjLlhzHKPh5NDt5+y7yed4j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEMWU4+lcZAufPaWfgIncKZdjxK7kqkEro+YaFdQnZ/u/CiSuhDXqejCUIo/RtKEE
         bGND9Z1Yx7E+p6NN336VoaHGClUG3586BZODx4PJtJBN/wRO77ExDd7+s8GlQb+1eZ
         nBkkXPMJXnZpR1P8CFS5NbaRUvuse0HBX/Y2Po2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas MURE <nicolas.mure2019@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 058/127] ALSA: usb-audio: Configure Pioneer DJM-850 samplerate
Date:   Mon, 24 May 2021 17:26:15 +0200
Message-Id: <20210524152336.801530757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas MURE <nicolas.mure2019@gmail.com>

commit 1a2a94a4392d5d1e5e25cc127573452f4c7fa9b8 upstream.

Send an `URB_CONTROL out` USB frame to the device to configure its
samplerate. This should be done before using the device for audio
streaming (capture or playback).

See https://github.com/nm2107/Pioneer-DJM-850-driver-reverse-engineering/blob/172fb9a61055960c88c67b7c416fe5bf3609807b/doc/windows-dvs/framerate-setting/README.md

Signed-off-by: Nicolas MURE <nicolas.mure2019@gmail.com>
Link: https://lore.kernel.org/r/20210301152729.18094-4-nicolas.mure2019@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1511,6 +1511,9 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
 		pioneer_djm_set_format_quirk(subs, 0x0082);
 		break;
+	case USB_ID(0x08e4, 0x0163): /* Pioneer DJM-850 */
+		pioneer_djm_set_format_quirk(subs, 0x0086);
+		break;
 	}
 }
 


