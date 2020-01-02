Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCEA12ECDD
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgABWWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbgABWWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:22:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75B7F22B48;
        Thu,  2 Jan 2020 22:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003761;
        bh=jAIf3CT/v5lg8WB6/KwtNml/dKqKx7WIzBVB3nUMhVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeOpyoTa+KDXWHW3brteArU5ezoai+seunRaRCOCXTPeMaS4hW88glgxZm5zRrYWl
         rcmvMxwt8nvHbBwCIbRVjZMp96dkxFHTSBuFz6mw/GYyI583g0hEu3gBWaTmuQ5f8K
         B5uT7czkSqfPXeObmShDmG42buR4QK3uQQWEQ4hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b3028ac3933f5c466389@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/114] ALSA: hda - Downgrade error message for single-cmd fallback
Date:   Thu,  2 Jan 2020 23:07:29 +0100
Message-Id: <20200102220036.847521443@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 475feec0c41ad71cb7d02f0310e56256606b57c5 ]

We made the error message for the CORB/RIRB communication clearer by
upgrading to dev_WARN() so that user can notice better.  But this
struck us like a boomerang: now it caught syzbot and reported back as
a fatal issue although it's not really any too serious bug that worth
for stopping the whole system.

OK, OK, let's be softy, downgrade it to the standard dev_err() again.

Fixes: dd65f7e19c69 ("ALSA: hda - Show the fatal CORB/RIRB error more clearly")
Reported-by: syzbot+b3028ac3933f5c466389@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20191216151224.30013-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 8fcb421193e0..fa261b27d858 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -883,7 +883,7 @@ static int azx_rirb_get_response(struct hdac_bus *bus, unsigned int addr,
 		return -EAGAIN; /* give a chance to retry */
 	}
 
-	dev_WARN(chip->card->dev,
+	dev_err(chip->card->dev,
 		"azx_get_response timeout, switching to single_cmd mode: last cmd=0x%08x\n",
 		bus->last_cmd[addr]);
 	chip->single_cmd = 1;
-- 
2.20.1



