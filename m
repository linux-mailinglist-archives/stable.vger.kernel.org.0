Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433223E7EA6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhHJRei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232568AbhHJReM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D12686101E;
        Tue, 10 Aug 2021 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616830;
        bh=LfJ98tku/+Xdhhxm5bi6EePlLmjB6Xhx5eVKb+R0OJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5QARRXlHBUOt6A8X8dK+qGGM1AaIhZuQjeKkqy/8ButRkDg4hPLBDf7Ch3w9EFJ3
         3MwDvnOJL1Lhtf/Dimw4v+cwIrwWkkpXS3S3SM4W8QBvn39HCqyFuiQ3upb9/ZnWpS
         xRnTLkxmXAz8jI57JxDdxXI8K1kYzU6sPuCiJqUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "chihhao.chen" <chihhao.chen@mediatek.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/85] ALSA: usb-audio: fix incorrect clock source setting
Date:   Tue, 10 Aug 2021 19:29:44 +0200
Message-Id: <20210810172948.586097186@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chihhao.chen <chihhao.chen@mediatek.com>

[ Upstream commit 4511781f95da0a3b2bad34f3f5e3967e80cd2d18 ]

The following scenario describes an echo test for
Samsung USBC Headset (AKG) with VID/PID (0x04e8/0xa051).

We first start a capture stream(USB IN transfer) in 96Khz/24bit/1ch mode.
In clock find source function, we get value 0x2 for clock selector
and 0x1 for clock source.

Kernel-4.14 behavior
Since clock source is valid so clock selector was not set again.
We pass through this function and start a playback stream(USB OUT transfer)
in 48Khz/32bit/2ch mode. This time we get value 0x1 for clock selector
and 0x1 for clock source. Finally clock id with this setting is 0x9.

Kernel-5.10 behavior
Clock selector was always set one more time even it is valid.
When we start a playback stream, we will get 0x2 for clock selector
and 0x1 for clock source. In this case clock id becomes 0xA.
This is an incorrect clock source setting and results in severe noises.
We see wrong data rate in USB IN transfer.
(From 288 bytes/ms becomes 144 bytes/ms) It should keep in 288 bytes/ms.

This earphone works fine on older kernel version load because
this is a newly-added behavior.

Fixes: d2e8f641257d ("ALSA: usb-audio: Explicitly set up the clock selector")
Signed-off-by: chihhao.chen <chihhao.chen@mediatek.com>
Link: https://lore.kernel.org/r/1627100621-19225-1-git-send-email-chihhao.chen@mediatek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 6a51b9d20eeb..3d1c0ec11753 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -319,6 +319,12 @@ static int __uac_clock_find_source(struct snd_usb_audio *chip,
 					      selector->baCSourceID[ret - 1],
 					      visited, validate);
 		if (ret > 0) {
+			/*
+			 * For Samsung USBC Headset (AKG), setting clock selector again
+			 * will result in incorrect default clock setting problems
+			 */
+			if (chip->usb_id == USB_ID(0x04e8, 0xa051))
+				return ret;
 			err = uac_clock_selector_set_val(chip, entity_id, cur);
 			if (err < 0)
 				return err;
-- 
2.30.2



