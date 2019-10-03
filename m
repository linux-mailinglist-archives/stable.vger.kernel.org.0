Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBC2CA55C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392034AbfJCQdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392025AbfJCQdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36D42070B;
        Thu,  3 Oct 2019 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120419;
        bh=xSp0s3xjdD6LHKjMRuHiGm3I43KY6sgKwlUbowY3+9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxYnTg+P9ZD3pWt53YCR11SoFqwQNflZb4eq+qe+VEAYa5ytvDpfv81aDWSQAtNUM
         R7T7KqDHW4NpMUe69VhHTVvYZk8vNKtJ5f4mpb9ftaZ4+Vi2BaatE/JVjOYDXLhs3T
         i/iqE9mZahtA6PfT7/C7K3IlPn/HiOT4KkNPO/FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 216/313] ALSA: firewire-tascam: handle error code when getting current source of clock
Date:   Thu,  3 Oct 2019 17:53:14 +0200
Message-Id: <20191003154554.285969591@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 2617120f4de6d0423384e0e86b14c78b9de84d5a upstream.

The return value of snd_tscm_stream_get_clock() is ignored. This commit
checks the value and handle error.

Fixes: e453df44f0d6 ("ALSA: firewire-tascam: add PCM functionality")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20190910135152.29800-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/tascam/tascam-pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/firewire/tascam/tascam-pcm.c
+++ b/sound/firewire/tascam/tascam-pcm.c
@@ -56,6 +56,9 @@ static int pcm_open(struct snd_pcm_subst
 		goto err_locked;
 
 	err = snd_tscm_stream_get_clock(tscm, &clock);
+	if (err < 0)
+		goto err_locked;
+
 	if (clock != SND_TSCM_CLOCK_INTERNAL ||
 	    amdtp_stream_pcm_running(&tscm->rx_stream) ||
 	    amdtp_stream_pcm_running(&tscm->tx_stream)) {


