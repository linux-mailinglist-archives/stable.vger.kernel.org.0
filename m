Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3BC200D34
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbgFSOy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389845AbgFSOy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:54:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2E6F2184D;
        Fri, 19 Jun 2020 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578466;
        bh=qygqLHqMezCX+6LgvnjdCDibWW+M3EltjTOt1L/yt30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb/RB8mlzEvFCCK9iPkbYI6ghjjkH9LMw5W/S5sXsmY48FBelJLt71z9Q48vzpQ6d
         C+ArGy92kwLHOVH/taU8Q1DQfnmU46+1Ydx6NmMWLl8CwP+iOC719Judd3/sSoD1vT
         vTC5NdUYljEg5Rr1NcZQkcDCVx5eqbZKwwdainsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 033/267] ALSA: es1688: Add the missed snd_card_free()
Date:   Fri, 19 Jun 2020 16:30:18 +0200
Message-Id: <20200619141650.442289608@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit d9b8fbf15d05350b36081eddafcf7b15aa1add50 upstream.

snd_es968_pnp_detect() misses a snd_card_free() in a failed path.
Add the missed function call to fix it.

Fixes: a20971b201ac ("ALSA: Merge es1688 and es968 drivers")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200603092459.1424093-1-hslester96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/isa/es1688/es1688.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -282,8 +282,10 @@ static int snd_es968_pnp_detect(struct p
 		return error;
 	}
 	error = snd_es1688_probe(card, dev);
-	if (error < 0)
+	if (error < 0) {
+		snd_card_free(card);
 		return error;
+	}
 	pnp_set_card_drvdata(pcard, card);
 	snd_es968_pnp_is_probed = 1;
 	return 0;


