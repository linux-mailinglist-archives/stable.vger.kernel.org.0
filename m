Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79B245C48D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351506AbhKXNtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354042AbhKXNso (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:48:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FF366334B;
        Wed, 24 Nov 2021 13:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758925;
        bh=d1FIuv/dVVxW19ZgxtqFuPC8CVQXUTdfjD91zC5VN2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgePeJrXHjzBGRqZjCdBrC32p/n/vOS/sJCUCyHtDsslNqR8r7KTmruw8BCjBxaMt
         ElrYXmCZDCPPtG0mcfVwIeYkkw4FZC6SSzM6aC9wObfrSu0IbbzINxjNY9BydDYyWH
         Hcbk6xWS5f336TjF7d+oht8bkQbbxI7/0eeWMm04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/279] ALSA: usb-audio: fix null pointer dereference on pointer cs_desc
Date:   Wed, 24 Nov 2021 12:56:02 +0100
Message-Id: <20211124115721.300496535@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit b97053df0f04747c3c1e021ecbe99db675342954 ]

The pointer cs_desc return from snd_usb_find_clock_source could
be null, so there is a potential null pointer dereference issue.
Fix this by adding a null check before dereference.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Link: https://lore.kernel.org/r/20211024111736.11342-1-cyeaa@connect.ust.hk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 81d5ce07d548b..98345a695dccb 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -496,6 +496,10 @@ int snd_usb_set_sample_rate_v2v3(struct snd_usb_audio *chip,
 	union uac23_clock_source_desc *cs_desc;
 
 	cs_desc = snd_usb_find_clock_source(chip, clock, fmt->protocol);
+
+	if (!cs_desc)
+		return 0;
+
 	if (fmt->protocol == UAC_VERSION_3)
 		bmControls = le32_to_cpu(cs_desc->v3.bmControls);
 	else
-- 
2.33.0



