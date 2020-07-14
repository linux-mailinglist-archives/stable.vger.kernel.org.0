Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1321FC0C
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgGNSxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgGNSxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:53:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7090F207F5;
        Tue, 14 Jul 2020 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752800;
        bh=VNLiK8TeBYmWAMxY/YD4soQp/ZXucvsXLee0gy0MjLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR9f5pCouzyhqhUk3pgYi2ZZpBDnzmEiMw/IXDDzjvKGKtJpYu/iI3UecLgGnG3xB
         j31uXUFXeiMlnCNDr/AMu4QFAK99fLBqCOLt2mV8HmrkGrNObbWNrBwWinWawkwH4x
         2iF978OGffN3nBVaHtkYH48Gvbhig9Xmy+UbHnR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Hofman <pavel.hofman@ivitera.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 075/109] ALSA: usb-audio: Add implicit feedback quirk for RTX6001
Date:   Tue, 14 Jul 2020 20:44:18 +0200
Message-Id: <20200714184109.128454170@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit b6a1e78b96a5d7f312f08b3a470eb911ab5feec0 upstream.

USB Audio analyzer RTX6001 uses the same implicit feedback quirk
as other XMOS-based devices.

Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Tested-by: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/822f0f20-1886-6884-a6b2-d11c685cbafa@ivitera.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -350,6 +350,7 @@ static int set_sync_ep_implicit_fb_quirk
 		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
 	case USB_ID(0x31e9, 0x0002): /* Solid State Logic SSL2+ */
+	case USB_ID(0x0d9a, 0x00df): /* RTX6001 */
 		ep = 0x81;
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;


