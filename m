Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C311FE48D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgFRCTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgFRBTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6891221D7E;
        Thu, 18 Jun 2020 01:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443161;
        bh=kUGcVXRVxnsE4PRZ85J75kYg4bxTrLdCNBvOPXpXS+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ve3ILFa37zhWTHeOkMPAyznMcleaCjbSI+Uuzl3g2+c6lZmLLD+lcpKS3WqWgPSUs
         +CkX87ik4cDlr9MvDvOuBXtiFSbXwV2eAD2+VVfzqgxSChkS9IW3ZyMzEk7dklptKR
         3ZDGxHhQYzSa+2DQHiInCdTdAzEKmeLQDexviUy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 127/266] ALSA: firewire-lib: fix invalid assignment to union data for directional parameter
Date:   Wed, 17 Jun 2020 21:14:12 -0400
Message-Id: <20200618011631.604574-127-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 67d735e9a6a4..fea92e148790 100644
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

