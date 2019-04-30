Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A20F8ED
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfD3MeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfD3MeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 08:34:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A7C62080C;
        Tue, 30 Apr 2019 12:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556627663;
        bh=eEdY8tKdyKGKmNzphCQVR1IKi70od7djz03T/mbFF9c=;
        h=Subject:To:From:Date:From;
        b=edmv9/zbToTT6U9tmX/jy2VN0ayqwHZLvX3DnkcGwAgrLByt55/2HY4ZpqaSyOBWH
         0T2ZghAer2wikK/Ci91hBn8l3xsc6zGEf5Favq2ZiGskTU+TvJ2OfpINaqJUNwe58N
         8MyrTj7o7wQbzXq4EhhFrU4F0yBlzzlrNrkcgXdo=
Subject: patch "staging: most: sound: pass correct device when creating a sound card" added to staging-testing
To:     christian.gromm@microchip.com, erosca@de.adit-jv.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 30 Apr 2019 14:34:21 +0200
Message-ID: <155662766110534@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: most: sound: pass correct device when creating a sound card

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 98592c1faca82a9024a64e4ecead68b19f81c299 Mon Sep 17 00:00:00 2001
From: Christian Gromm <christian.gromm@microchip.com>
Date: Tue, 30 Apr 2019 14:07:48 +0200
Subject: staging: most: sound: pass correct device when creating a sound card

This patch fixes the usage of the wrong struct device when calling
function snd_card_new.

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Signed-off-by: Christian Gromm <christian.gromm@microchip.com>
Fixes: 69c90cf1b2fa ("staging: most: sound: call snd_card_new with struct device")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/most/sound/sound.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/most/sound/sound.c b/drivers/staging/most/sound/sound.c
index 7c998673a6f8..342f390d68b3 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -613,7 +613,7 @@ static int audio_probe_channel(struct most_interface *iface, int channel_id,
 	INIT_LIST_HEAD(&adpt->dev_list);
 	iface->priv = adpt;
 	list_add_tail(&adpt->list, &adpt_list);
-	ret = snd_card_new(&iface->dev, -1, "INIC", THIS_MODULE,
+	ret = snd_card_new(iface->driver_dev, -1, "INIC", THIS_MODULE,
 			   sizeof(*channel), &adpt->card);
 	if (ret < 0)
 		goto err_free_adpt;
-- 
2.21.0


