Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9196927C48B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgI2LOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgI2LOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE9D221EC;
        Tue, 29 Sep 2020 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378087;
        bh=apXheJrvF9UwGoNCAJr1Ny8+KPRGtK5Z20uSuDveaZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ioc+TD+qiQxZHViokqCmyl+wwCaAPn8meDDO0wv3AOpY9H4kMu4B5j5vmhXOVbO6n
         ti6wW2RbaPA2/fljINIkzJh23cZzlVkvkOrGr2BfT8E6+PwKi6udBK9VikVilcJvWs
         rYwD/ikL4wmmvMqwF0wDt0DTAboGrHHIrfu16jFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 026/166] ALSA: usb-audio: Add delay quirk for H570e USB headsets
Date:   Tue, 29 Sep 2020 12:58:58 +0200
Message-Id: <20200929105936.505973703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
@@ -1322,12 +1322,13 @@ void snd_usb_ctl_msg_quirk(struct usb_de
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		mdelay(20);
 
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


