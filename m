Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8653C441E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhGLGR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhGLGR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A030D6101E;
        Mon, 12 Jul 2021 06:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070480;
        bh=cfK3vaQ4dVjoblIvE0JFFdfk0Mp5PbXOp+XaJBzwGqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfApztW73XwBQJua9QcpQ+6ElwiJao4tCJYp8G0mXaasX/BEO+3RT49YJ2Ts2609h
         d+N0oV6c31QdYoE1n63FlykxMREF6Qe7YJsGAzWLRJ27UrWJ7Y5CPseaYku+cob+Jz
         8YOMbd2T6vkRy5Xw8oRk1WB50jGDxYp2JohUXGfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daehwan Jung <dh10.jung@samsung.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 001/348] ALSA: usb-audio: fix rate on Ozone Z90 USB headset
Date:   Mon, 12 Jul 2021 08:06:25 +0200
Message-Id: <20210712060700.081515744@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daehwan Jung <dh10.jung@samsung.com>

commit aecc19ec404bdc745c781058ac97a373731c3089 upstream.

It mislabels its 96 kHz altsetting and that's why it causes some noise

Signed-off-by: Daehwan Jung <dh10.jung@samsung.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1623836097-61918-1-git-send-email-dh10.jung@samsung.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/format.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -195,9 +195,11 @@ static int parse_audio_format_rates_v1(s
 				continue;
 			/* C-Media CM6501 mislabels its 96 kHz altsetting */
 			/* Terratec Aureon 7.1 USB C-Media 6206, too */
+			/* Ozone Z90 USB C-Media, too */
 			if (rate == 48000 && nr_rates == 1 &&
 			    (chip->usb_id == USB_ID(0x0d8c, 0x0201) ||
 			     chip->usb_id == USB_ID(0x0d8c, 0x0102) ||
+			     chip->usb_id == USB_ID(0x0d8c, 0x0078) ||
 			     chip->usb_id == USB_ID(0x0ccd, 0x00b1)) &&
 			    fp->altsetting == 5 && fp->maxpacksize == 392)
 				rate = 96000;


