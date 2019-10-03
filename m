Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF127CA826
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388653AbfJCQWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390229AbfJCQWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCAF120865;
        Thu,  3 Oct 2019 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119720;
        bh=zrdNoSnOeNZj5QJjLU3IpZ0WHzz72+SQAhpLfEHBe8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md8OdiptVzGPkWvj9vlzb7RLUcXHabwCg0MIB706oF+JaM0pfXnQE5G1z/QOB3G9L
         C/IgPZLbBgzofazObLIroBYDrLbXq2Znswk3d6OuIQjB1VyCHYrW4ia8jcIgjcrzW3
         387I1WreIaZ+EGPWmjZ3hxgSOp8SECsulKMxP7xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Kellermann <max.kellermann@gmail.com>,
        Wolfgang Rohdewald <wolfgang@rohdewald.de>,
        Arnd Bergmann <arnd@arndb.de>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 169/211] media: dont drop front-end reference count for ->detach
Date:   Thu,  3 Oct 2019 17:53:55 +0200
Message-Id: <20191003154526.075951948@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 14e3cdbb00a885eedc95c0cf8eda8fe28d26d6b4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-core/dvb_frontend.c |    4 +++-
 drivers/media/usb/dvb-usb/pctv452e.c  |    8 --------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -164,6 +164,9 @@ static void dvb_frontend_free(struct kre
 
 static void dvb_frontend_put(struct dvb_frontend *fe)
 {
+	/* call detach before dropping the reference count */
+	if (fe->ops.detach)
+		fe->ops.detach(fe);
 	/*
 	 * Check if the frontend was registered, as otherwise
 	 * kref was not initialized yet.
@@ -3035,7 +3038,6 @@ void dvb_frontend_detach(struct dvb_fron
 	dvb_frontend_invoke_release(fe, fe->ops.release_sec);
 	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
-	dvb_frontend_invoke_release(fe, fe->ops.detach);
 	dvb_frontend_put(fe);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -913,14 +913,6 @@ static int pctv452e_frontend_attach(stru
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


