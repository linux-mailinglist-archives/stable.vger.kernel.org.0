Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D651673CF
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbgBUIPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbgBUIPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A03B624670;
        Fri, 21 Feb 2020 08:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272946;
        bh=gL1QEeR6PJrwA5ExvA/MU2u2t/8kiN9G1g+z+gyqnTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBLso7USxQA+uH05r42yGduzJCH0nAomhyRGfSrvLmVyr4wwxCIC9d2ZumeqDGa77
         OBlzAPXaDGj5fKHy6HE6QRHFY6D5nTpeOhPt77qtaVK6J33edYQQjNZjWxoM4huzhb
         3OM6AeuLmqsvRGiSaXbmwJMV7e5syrA5dswFhNHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicola Lunghi <nick83ola@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/344] ALSA: usb-audio: add quirks for Line6 Helix devices fw>=2.82
Date:   Fri, 21 Feb 2020 08:41:37 +0100
Message-Id: <20200221072416.959718850@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicola Lunghi <nick83ola@gmail.com>

[ Upstream commit b81cbf7abfc94878a3c6f0789f2185ee55b1cc21 ]

With firmware 2.82 Line6 changed the usb id of some of the Helix
devices but the quirks is still needed.

Add it to the quirk list for line6 helix family of devices.

Thanks to Jens for pointing out the missing ids.

Signed-off-by: Nicola Lunghi <nick83ola@gmail.com>
Link: https://lore.kernel.org/r/20200125150917.5040-1-nick83ola@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/format.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 25668ba5e68e3..f4f0cf3deaf0c 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -296,6 +296,9 @@ static int line6_parse_audio_format_rates_quirk(struct snd_usb_audio *chip,
 	case USB_ID(0x0E41, 0x4242): /* Line6 Helix Rack */
 	case USB_ID(0x0E41, 0x4244): /* Line6 Helix LT */
 	case USB_ID(0x0E41, 0x4246): /* Line6 HX-Stomp */
+	case USB_ID(0x0E41, 0x4248): /* Line6 Helix >= fw 2.82 */
+	case USB_ID(0x0E41, 0x4249): /* Line6 Helix Rack >= fw 2.82 */
+	case USB_ID(0x0E41, 0x424a): /* Line6 Helix LT >= fw 2.82 */
 		/* supported rates: 48Khz */
 		kfree(fp->rate_table);
 		fp->rate_table = kmalloc(sizeof(int), GFP_KERNEL);
-- 
2.20.1



