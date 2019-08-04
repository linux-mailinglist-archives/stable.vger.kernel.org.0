Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9779980A18
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 11:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfHDJjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 05:39:45 -0400
Received: from www.linuxtv.org ([130.149.80.248]:39200 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHDJjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 05:39:44 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1huCzM-0002Gn-W1; Sun, 04 Aug 2019 09:39:40 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Sun, 04 Aug 2019 09:33:11 +0000
Subject: [git:media_tree/master] media: don't drop front-end reference count for ->detach
To:     linuxtv-commits@linuxtv.org
Cc:     Wolfgang Rohdewald <wolfgang@rohdewald.de>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Max Kellermann <max.kellermann@gmail.com>,
        Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1huCzM-0002Gn-W1@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: don't drop front-end reference count for ->detach
Author:  Arnd Bergmann <arnd@arndb.de>
Date:    Wed Jun 19 10:24:17 2019 -0300

A bugfix introduce a link failure in configurations without CONFIG_MODULES:

In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:0:
drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak declaration of 'stb0899_attach' being applied to a already existing, static definition

The problem is that the !IS_REACHABLE() declaration of stb0899_attach()
is a 'static inline' definition that clashes with the weak definition.

I further observed that the bugfix was only done for one of the five users
of stb0899_attach(), the other four still have the problem.  This reverts
the bugfix and instead addresses the problem by not dropping the reference
count when calling '->detach()', instead we call this function directly
in dvb_frontend_put() before dropping the kref on the front-end.

I first submitted this in early 2018, and after some discussion it
was apparently discarded.  While there is a long-term plan in place,
that plan is obviously not nearing completion yet, and the current
kernel is still broken unless this patch is applied.

Link: https://patchwork.kernel.org/patch/10140175/
Link: https://patchwork.linuxtv.org/patch/54831/

Cc: Max Kellermann <max.kellermann@gmail.com>
Cc: Wolfgang Rohdewald <wolfgang@rohdewald.de>
Cc: stable@vger.kernel.org
Fixes: f686c14364ad ("[media] stb0899: move code to "detach" callback")
Fixes: 6cdeaed3b142 ("media: dvb_usb_pctv452e: module refcount changes were unbalanced")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/dvb-core/dvb_frontend.c | 4 +++-
 drivers/media/usb/dvb-usb/pctv452e.c  | 8 --------
 2 files changed, 3 insertions(+), 9 deletions(-)

---

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 209186c5cd9b..06ea30a689d7 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -152,6 +152,9 @@ static void dvb_frontend_free(struct kref *ref)
 
 static void dvb_frontend_put(struct dvb_frontend *fe)
 {
+	/* call detach before dropping the reference count */
+	if (fe->ops.detach)
+		fe->ops.detach(fe);
 	/*
 	 * Check if the frontend was registered, as otherwise
 	 * kref was not initialized yet.
@@ -3040,7 +3043,6 @@ void dvb_frontend_detach(struct dvb_frontend *fe)
 	dvb_frontend_invoke_release(fe, fe->ops.release_sec);
 	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
-	dvb_frontend_invoke_release(fe, fe->ops.detach);
 	dvb_frontend_put(fe);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index d6b36e4f33d2..441d878fc22c 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -909,14 +909,6 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
 						&a->dev->i2c_adap);
 	if (!a->fe_adap[0].fe)
 		return -ENODEV;
-
-	/*
-	 * dvb_frontend will call dvb_detach for both stb0899_detach
-	 * and stb0899_release but we only do dvb_attach(stb0899_attach).
-	 * Increment the module refcount instead.
-	 */
-	symbol_get(stb0899_attach);
-
 	if ((dvb_attach(lnbp22_attach, a->fe_adap[0].fe,
 					&a->dev->i2c_adap)) == NULL)
 		err("Cannot attach lnbp22\n");
