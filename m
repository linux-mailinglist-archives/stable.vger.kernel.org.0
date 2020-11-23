Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3312C069E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbgKWMcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731130AbgKWMct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860BF20728;
        Mon, 23 Nov 2020 12:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134769;
        bh=KfiVTUPDn9XdCvl5t8yWBT3EQmYTDUqEzT1mSrp4Bcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/1oHFaGyUZvcT8BZ74C1oNQ9fUoJloQtUdtdfno1sMuiv9Dhouy9uCNi8AeYAdDv
         D2XL66M4LnOidMbWo1qFcyy4NV7FKXvT1YJVCPtXPds/0m38zKzKLL+7IG5yxHJRk1
         7J7HnhTlDlUdFkEKHdyUfuYyP2U3Tf3Tjtbk3CwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 68/91] ALSA: usb-audio: Add delay quirk for all Logitech USB devices
Date:   Mon, 23 Nov 2020 13:22:28 +0100
Message-Id: <20201123121812.628822307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <joakim.tjernlund@infinera.com>

commit 54a2a3898f469a915510038fe84ef4f083131d3e upstream.

Found one more Logitech device, BCC950 ConferenceCam, which needs
the same delay here. This makes 3 out of 3 devices I have tried.

Therefore, add a delay for all Logitech devices as it does not hurt.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: <stable@vger.kernel.org> # 4.19.y, 5.4.y
Link: https://lore.kernel.org/r/20201117122803.24310-1-joakim.tjernlund@infinera.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1338,13 +1338,13 @@ void snd_usb_ctl_msg_quirk(struct usb_de
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
-	/* Zoom R16/24, Logitech H650e/H570e, Jabra 550a, Kingston HyperX
-	 *  needs a tiny delay here, otherwise requests like get/set
-	 *  frequency return as failed despite actually succeeding.
+	/* Zoom R16/24, many Logitech(at least H650e/H570e/BCC950),
+	 * Jabra 550a, Kingston HyperX needs a tiny delay here,
+	 * otherwise requests like get/set frequency return
+	 * as failed despite actually succeeding.
 	 */
 	if ((chip->usb_id == USB_ID(0x1686, 0x00dd) ||
-	     chip->usb_id == USB_ID(0x046d, 0x0a46) ||
-	     chip->usb_id == USB_ID(0x046d, 0x0a56) ||
+	     USB_ID_VENDOR(chip->usb_id) == 0x046d  || /* Logitech */
 	     chip->usb_id == USB_ID(0x0b0e, 0x0349) ||
 	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)


