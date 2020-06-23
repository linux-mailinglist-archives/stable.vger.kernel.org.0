Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C23520660D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbgFWVgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388714AbgFWUJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 037D320E65;
        Tue, 23 Jun 2020 20:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942968;
        bh=LWrU2odKBmE+FGHvUwgpN2pqOAW6X870RH4Af62eFBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yS5Q5RlLVzZ2T4yfZ36z8ZtjJaym/n/tUkTUbkd8yZ6V9EQUA91edGxgbKHrYjJ8D
         dmC1dEMV+U6mzkTTzP5lV4q1bACFCnAyqCpMcz0Aucq20qedSRlwk00WaO2VMXm1Pn
         uLZehHcz+Qd3BalYod/XBE4TunQdpPgtQQ80uOU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 176/477] ALSA: firewire-lib: fix invalid assignment to union data for directional parameter
Date:   Tue, 23 Jun 2020 21:52:53 +0200
Message-Id: <20200623195415.900242027@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 8304cf77c92038cd1c50c27b69d30be695cc8003 ]

Although the value of FDF is used just for outgoing stream, the assignment
to union member is done for both directions of stream. At present this
causes no issue because the value of same position is reassigned later for
opposite stream. However, it's better to add if statement.

Fixes: d3d10a4a1b19 ("ALSA: firewire-lib: use union for directional parameters")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200508043635.349339-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/amdtp-am824.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/firewire/amdtp-am824.c b/sound/firewire/amdtp-am824.c
index 67d735e9a6a4c..fea92e148790f 100644
--- a/sound/firewire/amdtp-am824.c
+++ b/sound/firewire/amdtp-am824.c
@@ -82,7 +82,8 @@ int amdtp_am824_set_parameters(struct amdtp_stream *s, unsigned int rate,
 	if (err < 0)
 		return err;
 
-	s->ctx_data.rx.fdf = AMDTP_FDF_AM824 | s->sfc;
+	if (s->direction == AMDTP_OUT_STREAM)
+		s->ctx_data.rx.fdf = AMDTP_FDF_AM824 | s->sfc;
 
 	p->pcm_channels = pcm_channels;
 	p->midi_ports = midi_ports;
-- 
2.25.1



