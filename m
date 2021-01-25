Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5011E304AA6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbhAZFAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbhAYSvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2D942310A;
        Mon, 25 Jan 2021 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600652;
        bh=ZRdEgExoQGaP23kwrINMhYQZYgcDHq3m22r39Cu4ZFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzneQR0NC+OFflhrMa8V2++AfrG+kl+ynTwbdD/NUvPtwNX2IRbXmSjLzMFxRRdRW
         PtGeWCFh4jIv4L8eOxXe8kLkej/qIA4Fpb88FuRpw3RWgiaz5dUB+9LtZmYwCBu6Zt
         hfq96PleY2gMzukDpyGxT1ExwSf3/R+JpYFnjPWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Takashi Iwai <tiwai@suse.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/199] drm/vc4: Unify PCM cards driver_name
Date:   Mon, 25 Jan 2021 19:38:41 +0100
Message-Id: <20210125183220.457534182@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 33c74535b03ecf11359de14bc88302595b1de44f ]

User-space ALSA matches a card's driver name against an internal list of
aliases in order to select the correct configuration for the system.
When the driver name isn't defined, the match is performed against the
card's name.

With the introduction of RPi4 we now have two HDMI ports with two
distinct audio cards. This is reflected in their names, making them
different from previous RPi versions. With this, ALSA ultimately misses
the board's configuration on RPi4.

In order to avoid this, set "card->driver_name" to "vc4-hdmi"
unanimously.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Fixes: f437bc1ec731 ("drm/vc4: drv: Support BCM2711")
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210115191209.12852-1-nsaenzjulienne@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index afc178b0d89f4..eaba98e15de46 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1268,6 +1268,7 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 	card->dai_link = dai_link;
 	card->num_links = 1;
 	card->name = vc4_hdmi->variant->card_name;
+	card->driver_name = "vc4-hdmi";
 	card->dev = dev;
 	card->owner = THIS_MODULE;
 
-- 
2.27.0



