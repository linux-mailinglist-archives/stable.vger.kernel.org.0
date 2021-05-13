Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B89137FAD1
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhEMPf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234914AbhEMPfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86F5C611AC;
        Thu, 13 May 2021 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920082;
        bh=MeSSwioHUHHjfwJxkcPen9z08/OrogpnzomxvdLyg18=;
        h=Subject:To:From:Date:From;
        b=Zo0vIga+0xZu1jtrOX+L1w/jFK1SAB7JocvW67MrIHHt8EZ0LcTPagUNw+PzkQDER
         pmm6N/wFymo64VsLHdWE7QZ19WGpYDmkFgR/TMg1dtA366wIGJAl0NaLz34an0ScsV
         SHnsyOn+nY8C1NYBk1dAs1RiP49PgQRDG/RSEF/g=
Subject: patch "Revert "ALSA: sb8: add a check for request_region"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, kjlu@umn.edu, stable@vger.kernel.org,
        tiwai@suse.de
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:18 +0200
Message-ID: <1620920058207156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "ALSA: sb8: add a check for request_region"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 94f88309f201821073f57ae6005caefa61bf7b7e Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:57:01 +0200
Subject: Revert "ALSA: sb8: add a check for request_region"

This reverts commit dcd0feac9bab901d5739de51b3f69840851f8919.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit message for this change was incorrect as the code
path can never result in a NULL dereference, alluding to the fact that
whatever tool was used to "find this" is broken.  It's just an optional
resource reservation, so removing this check is fine.

Cc: Kangjie Lu <kjlu@umn.edu>
Acked-by: Takashi Iwai <tiwai@suse.de>
Fixes: dcd0feac9bab ("ALSA: sb8: add a check for request_region")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-35-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sb/sb8.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 6c9d534ce8b6..95290ffe5c6e 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -95,10 +95,6 @@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)
 
 	/* block the 0x388 port to avoid PnP conflicts */
 	acard->fm_res = request_region(0x388, 4, "SoundBlaster FM");
-	if (!acard->fm_res) {
-		err = -EBUSY;
-		goto _err;
-	}
 
 	if (port[dev] != SNDRV_AUTO_PORT) {
 		if ((err = snd_sbdsp_create(card, port[dev], irq[dev],
-- 
2.31.1


