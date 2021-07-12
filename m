Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530783C4B75
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbhGLG5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240671AbhGLG4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 972D460FD8;
        Mon, 12 Jul 2021 06:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072812;
        bh=564gqs7cSvVVtf2TdRvrgZNJPnKPrfMkMOOu0nDGAS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0ARVhkoTeqeM3CXRAwVpPRO5QTadWqoYKPGrZvbuNGSP/XzO5MirepECGsDHLyAV
         qfE4HSY8ZaB6dCc8G+gm49U37J6QWNqRs6vryiyCrOp4GwWKmLlPuMTOTHafvtgXmw
         29Z6RqrVbDCHcKYO5EXkPvRe+8a7oGn9pfoMXagk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daehwan Jung <dh10.jung@samsung.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 004/700] ALSA: usb-audio: fix rate on Ozone Z90 USB headset
Date:   Mon, 12 Jul 2021 08:01:27 +0200
Message-Id: <20210712060925.406301050@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -223,9 +223,11 @@ static int parse_audio_format_rates_v1(s
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


