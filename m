Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA32634527A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 23:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCVWiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 18:38:01 -0400
Received: from www.linuxtv.org ([130.149.80.248]:36342 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhCVWh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 18:37:26 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lOTAr-00Awjc-1W; Mon, 22 Mar 2021 22:37:25 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 22 Mar 2021 22:36:39 +0000
Subject: [git:media_tree/master] media: dvbdev: Fix memory leak in dvb_media_device_free()
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lOTAr-00Awjc-1W@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dvbdev: Fix memory leak in dvb_media_device_free()
Author:  Peilin Ye <yepeilin.cs@gmail.com>
Date:    Fri Dec 11 09:30:39 2020 +0100

dvb_media_device_free() is leaking memory. Free `dvbdev->adapter->conn`
before setting it to NULL, as documented in include/media/media-device.h:
"The media_entity instance itself must be freed explicitly by the driver
if required."

Link: https://syzkaller.appspot.com/bug?id=9bbe4b842c98f0ed05c5eed77a226e9de33bf298

Link: https://lore.kernel.org/linux-media/20201211083039.521617-1-yepeilin.cs@gmail.com
Cc: stable@vger.kernel.org
Fixes: 0230d60e4661 ("[media] dvbdev: Add RF connector if needed")
Reported-by: syzbot+7f09440acc069a0d38ac@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/dvb-core/dvbdev.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 5ff7bedee247..3862ddc86ec4 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -241,6 +241,7 @@ static void dvb_media_device_free(struct dvb_device *dvbdev)
 
 	if (dvbdev->adapter->conn) {
 		media_device_unregister_entity(dvbdev->adapter->conn);
+		kfree(dvbdev->adapter->conn);
 		dvbdev->adapter->conn = NULL;
 		kfree(dvbdev->adapter->conn_pads);
 		dvbdev->adapter->conn_pads = NULL;
