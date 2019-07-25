Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB3974846
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388172AbfGYHhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388161AbfGYHhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:37:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46DE22CBC;
        Thu, 25 Jul 2019 07:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564040233;
        bh=tcScNLjjelD2TBiKIYrCQA/Axtq6uQldCyNINoUFdZk=;
        h=Subject:To:From:Date:From;
        b=qjeYuBCyTIVWQBcsXvlV6txClVCMaiFuYpfgH41U+p/8GHDW6N7eVIZtbrGhJ74em
         l2Y71vCybLBBIOcqZk9NmoqeNSVEIuaSLRDk5wJNX7WpgYBJt4Gf409gx2h/VM+jvu
         OF3G8bYBvehmRkTLgQhNYcXPeidcJjJMXORoUbf4=
Subject: patch "Staging: fbtft: Fix reset assertion when using gpio descriptor" added to staging-linus
To:     preid@electromag.com.au, gregkh@linuxfoundation.org,
        linux@jaseg.net, nsaenzjulienne@suse.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 09:37:02 +0200
Message-ID: <156404022213134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Staging: fbtft: Fix reset assertion when using gpio descriptor

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b918d1c2706619cb0712a61cc8c05148b68b24b2 Mon Sep 17 00:00:00 2001
From: Phil Reid <preid@electromag.com.au>
Date: Tue, 16 Jul 2019 08:24:37 +0800
Subject: Staging: fbtft: Fix reset assertion when using gpio descriptor
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Typically gpiod_set_value calls would assert the reset line and
then release it using the symantics of:
	gpiod_set_value(par->gpio.reset, 0);
	... delay
	gpiod_set_value(par->gpio.reset, 1);
And the gpio binding would specify the polarity.

Prior to conversion to gpiod calls the polarity in the DT
was ignored and assumed to be active low. Fix it so that
DT polarity is respected.

Fixes: c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor interface")
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jan Sebastian Götte <linux@jaseg.net>
Signed-off-by: Phil Reid <preid@electromag.com.au>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1563236677-5045-3-git-send-email-preid@electromag.com.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fbtft/fbtft-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index b963cccdc3f6..c3179cc847f8 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -231,9 +231,9 @@ static void fbtft_reset(struct fbtft_par *par)
 	if (!par->gpio.reset)
 		return;
 	fbtft_par_dbg(DEBUG_RESET, par, "%s()\n", __func__);
-	gpiod_set_value_cansleep(par->gpio.reset, 0);
-	usleep_range(20, 40);
 	gpiod_set_value_cansleep(par->gpio.reset, 1);
+	usleep_range(20, 40);
+	gpiod_set_value_cansleep(par->gpio.reset, 0);
 	msleep(120);
 }
 
-- 
2.22.0


