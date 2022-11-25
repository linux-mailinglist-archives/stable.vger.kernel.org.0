Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E72F6387D4
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 11:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKYKuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 05:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiKYKuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 05:50:14 -0500
X-Greylist: delayed 2243 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Nov 2022 02:50:13 PST
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F1E48424
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 02:50:13 -0800 (PST)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1oyVhP-00CdFD-FD; Fri, 25 Nov 2022 10:12:47 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Fri, 25 Nov 2022 10:02:57 +0000
Subject: [git:media_stage/master] media: dvb-core: Fix double free in dvb_register_device()
To:     linuxtv-commits@linuxtv.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1oyVhP-00CdFD-FD@www.linuxtv.org>
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dvb-core: Fix double free in dvb_register_device()
Author:  Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Date:    Tue Apr 26 06:29:19 2022 +0100

In function dvb_register_device() -> dvb_register_media_device() ->
dvb_create_media_entity(), dvb->entity is allocated and initialized. If
the initialization fails, it frees the dvb->entity, and return an error
code. The caller takes the error code and handles the error by calling
dvb_media_device_free(), which unregisters the entity and frees the
field again if it is not NULL. As dvb->entity may not NULLed in
dvb_create_media_entity() when the allocation of dvbdev->pad fails, a
double free may occur. This may also cause an Use After free in
media_device_unregister_entity().

Fix this by storing NULL to dvb->entity when it is freed.

Link: https://lore.kernel.org/linux-media/20220426052921.2088416-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Fixes: fcd5ce4b3936 ("media: dvb-core: fix a memory leak bug")
Cc: stable@vger.kernel.org
Cc: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/dvb-core/dvbdev.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index d5a142ef9876..5b275a9395c1 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -333,6 +333,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}
