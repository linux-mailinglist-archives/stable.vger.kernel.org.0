Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE69B1671C5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgBUH5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbgBUH5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:57:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E67320578;
        Fri, 21 Feb 2020 07:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271829;
        bh=i0ttOQxN0z0/Ta+VR+Huvh00r/qVH5VVQyPCyChB4BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWP8ps81d0pR450K8W5qZYWj9inVqX+EN5I7D89aA3NdnxM4HwkdNVG3++k+8Zisz
         hbTvVv7Y2GUh9j08BUyaW91C9QgaEkG7yFpH/fgN8MBqmK8huSyQAsUsywZaOLarzp
         EmYDFRXOGfCGcYxF6t70cdMqpdvQm1V2Ki2+AybU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 277/399] ALSA: usb-audio: add implicit fb quirk for MOTU M Series
Date:   Fri, 21 Feb 2020 08:40:02 +0100
Message-Id: <20200221072428.997803104@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit c249177944b650816069f6c49b769baaa94339dc ]

This fixes crackling sound during playback.

Further note: MOTU is known for reusing Product IDs for different
devices or different generations of the device (e.g. MicroBook
I/II/IIc shares a single Product ID). This patch was only tested with
M4 audio interface, but the same Product ID is also used by M2. Hope
it will work for M2 as well.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20200115151358.56672-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 0e4eab96e23e0..c9e1609296dff 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -348,6 +348,10 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 		ep = 0x84;
 		ifnum = 0;
 		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
+		ep = 0x81;
+		ifnum = 2;
+		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x0582, 0x01d8): /* BOSS Katana */
 		/* BOSS Katana amplifiers do not need quirks */
 		return 0;
-- 
2.20.1



