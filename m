Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA912AB9D2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbgKINM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732790AbgKINM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E598120867;
        Mon,  9 Nov 2020 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927577;
        bh=qqM8fld1mPbAkJuOP9dwtCix1uh4s+x2Oa0KxWheefs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+LF4SO+hUcF6Q1IgWTU0k/oUWb9MUeGAC3t+DjJ8BaYIUCGDuiN34+/i3cudRlnv
         qIHfA470ZiHwt6RRUwltmYz48gVfnHj/73PTsIcnXGBa6CG2DuZWIiFqJ+6dcPpDMH
         7VBeoRoPdoaRqh0YfGwYEeQBvSo4Sy31eukibHMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Frank Slotta <frank.slotta@posteo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 28/85] ALSA: usb-audio: Add implicit feedback quirk for MODX
Date:   Mon,  9 Nov 2020 13:55:25 +0100
Message-Id: <20201109125023.932874776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

commit 26201ddc1373c99b2a67c5774da2f0eecd749b93 upstream.

This patch fixes audio distortion on playback for the Yamaha MODX.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Tested-by: Frank Slotta <frank.slotta@posteo.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201104120705.GA19126@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -333,6 +333,7 @@ static int set_sync_ep_implicit_fb_quirk
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x2466, 0x8003): /* Fractal Audio Axe-Fx II */
+	case USB_ID(0x0499, 0x172a): /* Yamaha MODX */
 		ep = 0x86;
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;


