Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E7821FB06
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgGNS6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730806AbgGNS6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584F8229CA;
        Tue, 14 Jul 2020 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753082;
        bh=sBNdJl4w5KzMHk76Q+hkYXFrJJggdaSJ9oZroUN7ooM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACjJABMusfg0j6jzYo0iSh3dOxx63fVaDa91ERRR1lw36vTXTfy1HsCNZXwUI46oO
         JTdro4axfJC8QgNx4Yn0t+Z0vf43jZxZB6V748DJ1NEtDNhz+2P/iaTEuOPvbDR9MM
         TZtWcxY+NmrnBUuQXf3az664gQPs5aVB7vY23GYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Hofman <pavel.hofman@ivitera.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 112/166] ALSA: usb-audio: Add implicit feedback quirk for RTX6001
Date:   Tue, 14 Jul 2020 20:44:37 +0200
Message-Id: <20200714184121.200567985@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
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
@@ -368,6 +368,7 @@ static int set_sync_ep_implicit_fb_quirk
 		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
 	case USB_ID(0x31e9, 0x0002): /* Solid State Logic SSL2+ */
+	case USB_ID(0x0d9a, 0x00df): /* RTX6001 */
 		ep = 0x81;
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;


