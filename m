Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B342200BF7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbgFSOkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388099AbgFSOkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:40:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CBE5208B8;
        Fri, 19 Jun 2020 14:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577600;
        bh=wDH/5okJyIGslq/z6aOXJ/16hU1tvR3xkoeeS4hjMNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvkdqSAkXJFUG6slp7rbZwWwAoiv8unQzCe/GoPcnxoiPHrFm1D+2HuHCkJef0SZE
         gdGff6iqwyKeOjAMCSK2DDl1u8N+0nQ/CFR9Vrfhdy7CMqU8LazqCl4yGhg3T0nt+7
         nPgOnrUrXm9mAkN1MTbyPUf3Do6RTb4IPwyEcHbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 014/128] ALSA: es1688: Add the missed snd_card_free()
Date:   Fri, 19 Jun 2020 16:31:48 +0200
Message-Id: <20200619141620.902615153@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
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
@@ -284,8 +284,10 @@ static int snd_es968_pnp_detect(struct p
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


