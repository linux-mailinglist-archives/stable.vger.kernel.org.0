Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9E91FB9B3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgFPPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732398AbgFPPsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992CC20E65;
        Tue, 16 Jun 2020 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322496;
        bh=KERNEO/I/JhTJOE7gZeiLLtKqNd+wcWeZV80AwRWTDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNNBHrxXHhWAyDnp6B0IQ3qxRrSPP1AhNHUIY4SmXrUvdVb8Nn9y2gzaS6X5eZbLw
         d6X6KmeKPyZp9nQ7Fz1uSuUnn7TYG2XlhEjemTWUuPlzfx+mB5dOl41uMO/Exu83jV
         qCAtkEwCxVpzmQiWmnvP2ozn1aFP16scH/rc8HbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Antonino Daplas <adaplas@pol.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.7 125/163] video: fbdev: w100fb: Fix a potential double free.
Date:   Tue, 16 Jun 2020 17:34:59 +0200
Message-Id: <20200616153112.800527362@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 18722d48a6bb9c2e8d046214c0a5fd19d0a7c9f6 upstream.

Some memory is vmalloc'ed in the 'w100fb_save_vidmem' function and freed in
the 'w100fb_restore_vidmem' function. (these functions are called
respectively from the 'suspend' and the 'resume' functions)

However, it is also freed in the 'remove' function.

In order to avoid a potential double free, set the corresponding pointer
to NULL once freed in the 'w100fb_restore_vidmem' function.

Fixes: aac51f09d96a ("[PATCH] w100fb: Rewrite for platform independence")
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: <stable@vger.kernel.org> # v2.6.14+
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200506181902.193290-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/w100fb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -588,6 +588,7 @@ static void w100fb_restore_vidmem(struct
 		memsize=par->mach->mem->size;
 		memcpy_toio(remapped_fbuf + (W100_FB_BASE-MEM_WINDOW_BASE), par->saved_extmem, memsize);
 		vfree(par->saved_extmem);
+		par->saved_extmem = NULL;
 	}
 	if (par->saved_intmem) {
 		memsize=MEM_INT_SIZE;
@@ -596,6 +597,7 @@ static void w100fb_restore_vidmem(struct
 		else
 			memcpy_toio(remapped_fbuf + (W100_FB_BASE-MEM_WINDOW_BASE), par->saved_intmem, memsize);
 		vfree(par->saved_intmem);
+		par->saved_intmem = NULL;
 	}
 }
 


