Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE315DD82
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388562AbgBNP64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388740AbgBNP64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B802467C;
        Fri, 14 Feb 2020 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695935;
        bh=AWcXrUPmg1Ok0gkYHL79LaRTs1+QfXtcYfPh5YIhW2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSlTUjqBqkTlCgefOQNUhLzg1x8O9OST6mdesnqR0dX83/cW/sO+PgNISqmbGgHOC
         s48PLn0gNgB8IkbxhQlcfo3/vnPivOEpdo9P7KgE4v/hriaWAURu4BERzxCw2UJqgf
         FmYU1x1WHJjMa8v7twAp52RQ8ANXYNvPb1YmboQw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicola Lunghi <nick83ola@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 470/542] ALSA: usb-audio: add quirks for Line6 Helix devices fw>=2.82
Date:   Fri, 14 Feb 2020 10:47:42 -0500
Message-Id: <20200214154854.6746-470-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d79db71305f63..53922f73467f4 100644
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

