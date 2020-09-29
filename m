Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5708227C717
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgI2LvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731155AbgI2Lsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83F282075F;
        Tue, 29 Sep 2020 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380118;
        bh=ip3rXdZYN7Pep/nPtXkOid9ibu49xobAY8klnCH35VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z47voQUMIc4npxLAedzrGm772OIJ46FWE+XucPhckKDEX1T5G3k+YpumGfVFf4kmi
         r0KaBsWIRuJqYtBtzCApI5qBRaOyxGg0gjiPKA5zxR2t4Y0MnLwcmzkooU+rx+aB1c
         mD305/7MX2Gd0u2qIbyY63O/x3dkS+mae5uroi7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 75/99] ALSA: usb-audio: Add delay quirk for H570e USB headsets
Date:   Tue, 29 Sep 2020 13:01:58 +0200
Message-Id: <20200929105933.426338873@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <joakim.tjernlund@infinera.com>

commit 315c7ad7a701baba28c628c4c5426b3d9617ceed upstream.

Needs the same delay as H650e

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200910085328.19188-1-joakim.tjernlund@infinera.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1668,12 +1668,13 @@ void snd_usb_ctl_msg_quirk(struct usb_de
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
-	/* Zoom R16/24, Logitech H650e, Jabra 550a, Kingston HyperX needs a tiny
-	 * delay here, otherwise requests like get/set frequency return as
-	 * failed despite actually succeeding.
+	/* Zoom R16/24, Logitech H650e/H570e, Jabra 550a, Kingston HyperX
+	 *  needs a tiny delay here, otherwise requests like get/set
+	 *  frequency return as failed despite actually succeeding.
 	 */
 	if ((chip->usb_id == USB_ID(0x1686, 0x00dd) ||
 	     chip->usb_id == USB_ID(0x046d, 0x0a46) ||
+	     chip->usb_id == USB_ID(0x046d, 0x0a56) ||
 	     chip->usb_id == USB_ID(0x0b0e, 0x0349) ||
 	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)


