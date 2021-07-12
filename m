Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D42D3C55B4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbhGLILo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353868AbhGLIDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A05A611AF;
        Mon, 12 Jul 2021 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076701;
        bh=RUgYJU9lVBC2ICShtr/4xi1A1kUmM72HxXtGzTEXXgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VY1+43r8/+QNnI/PVUOuh3qobEEokzYUMXg4ZUD+CJtQsBEryM7HWMio85iPm828
         tm7fi3VDNDG2Zrj5JzFVTMyBBhqXU7dToBxIULwbx7ZwJXv1y95KAnlysrT5Pr4tLW
         kg+HZoMI/oLj+RS9ivIJzKG2P7Ogz4Zx1hvhovkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 757/800] ALSA: firewire-lib: Fix amdtp_domain_start() when no AMDTP_OUT_STREAM stream is found
Date:   Mon, 12 Jul 2021 08:13:00 +0200
Message-Id: <20210712061047.329480916@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0cbbeaf370221fc469c95945dd3c1198865c5fe4 ]

The intent here is to return an error code if we don't find what we are
looking for in the 'list_for_each_entry()' loop.

's' is not NULL if the list is empty or if we scan the complete list.
Introduce a new 'found' variable to handle such cases.

Fixes: 60dd49298ec5 ("ALSA: firewire-lib: handle several AMDTP streams in callback handler of IRQ target")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/9c9a53a4905984a570ba5672cbab84f2027dedc1.1624560484.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/amdtp-stream.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index 5805c5de39fb..7a282d8e7148 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -1404,14 +1404,17 @@ int amdtp_domain_start(struct amdtp_domain *d, unsigned int ir_delay_cycle)
 	unsigned int queue_size;
 	struct amdtp_stream *s;
 	int cycle;
+	bool found = false;
 	int err;
 
 	// Select an IT context as IRQ target.
 	list_for_each_entry(s, &d->streams, list) {
-		if (s->direction == AMDTP_OUT_STREAM)
+		if (s->direction == AMDTP_OUT_STREAM) {
+			found = true;
 			break;
+		}
 	}
-	if (!s)
+	if (!found)
 		return -ENXIO;
 	d->irq_target = s;
 
-- 
2.30.2



