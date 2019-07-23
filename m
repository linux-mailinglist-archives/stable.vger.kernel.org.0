Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B9F71598
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbfGWKAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:00:14 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48603 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbfGWKAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:00:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 55A7F5E2;
        Tue, 23 Jul 2019 06:00:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:00:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DQkCyK
        mziX6eMPWSNkYc6l/BJ6MRUExh0XtZrRobNkc=; b=16QYPxmg/J8ajLu8zqBhb9
        2DZLP9vvJUsWmOhz2bfcCBPb5ua2HvXSTsMLFYYW1WLK8RxnjURKkEkiyHixRpKR
        CUTqwSGFt8R4XSwcO5BRNoe7bVZQE2KZRTbgplW2NEAkjP+FFAhfHG7mGTkPIm4+
        L3/dmYTGjoF3xnTLSnAm3FDn7m537IBpDhEiNfBTcpo5628JRZ7fXEpFAyXp5qne
        olsUBjSG/O0glWgV8c9gQZkTsjWq/SxOi6fV1UTZXJv7q7DeIiWeGpMJJXberWBj
        pyyfhRVUUHt/o8ScNcSmIQfi6W/02aJlP/sCxoMbTpwu3eTCQ2+buN3iTFy3wInw
        ==
X-ME-Sender: <xms:q9o2XRk3PtwHPT5Z_IV2naToUDslJZW-tJuH9abAkSDQfjdlOFOHOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:q9o2XX9OdKxMLcFJZsMUAj0aktqcR_hszfYAvOH5JMNvDtqgVKL1pw>
    <xmx:q9o2XXDK-L-TE9pGyf0sDfYH3exNrFp1VbxBNO_Q9x0uteQEny8Psg>
    <xmx:q9o2XQ3AoPjOUTe1w73_YegheBhAucycmHMv1c2_ezosTsGDLgagOw>
    <xmx:q9o2Xec1MXdRVY4xG8BpevEHtfEnkgFIdS8_ck8gXBuAumf5TSq3GA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3EAA80069;
        Tue, 23 Jul 2019 06:00:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] raid5-cache: Need to do start() part job after adding journal" failed to apply to 4.9-stable tree
To:     xni@redhat.com, axboe@kernel.dk, soltys@ziu.info,
        songliubraving@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:00:08 +0200
Message-ID: <1563876008245214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d9771f5ec46c282d518b453c793635dbdc3a2a94 Mon Sep 17 00:00:00 2001
From: Xiao Ni <xni@redhat.com>
Date: Fri, 14 Jun 2019 15:41:05 -0700
Subject: [PATCH] raid5-cache: Need to do start() part job after adding journal
 device

commit d5d885fd514f ("md: introduce new personality funciton start()")
splits the init job to two parts. The first part run() does the jobs that
do not require the md threads. The second part start() does the jobs that
require the md threads.

Now it just does run() in adding new journal device. It needs to do the
second part start() too.

Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
Cc: stable@vger.kernel.org #v4.9+
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b83bce2beb66..da94cbaa1a9e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7672,7 +7672,7 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
-	int err = -EEXIST;
+	int ret, err = -EEXIST;
 	int disk;
 	struct disk_info *p;
 	int first = 0;
@@ -7687,7 +7687,14 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		log_init(conf, rdev, false);
+		ret = log_init(conf, rdev, false);
+		if (ret)
+			return ret;
+
+		ret = r5l_start(conf->log);
+		if (ret)
+			return ret;
+
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)

