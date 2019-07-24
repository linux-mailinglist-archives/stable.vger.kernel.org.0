Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5576B73E5C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389760AbfGXUYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389941AbfGXTle (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BAC522ADB;
        Wed, 24 Jul 2019 19:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997292;
        bh=C3mhXCl2ZWYBLwyb38j1K9FbAQ3C3952L957kgeENwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5Qrn3epvH6ZgaIWHp3bnx/n+Qe0dtyywuZmP9qUnZ/UKGecClSjjEO2/eJooJMas
         OfczdAtEuf5+a+wIpy0WJkOBRR+8FTse4piiFiKI57+PghuNk7HU7C/7OObtAdqhYa
         mqQskYYwFYWmbUj1iOAf+pKWRwzESe8EDCizI6dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Marc Meledandri <m.meledandri@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.2 345/413] drm/nouveau/i2c: Enable i2c pads & busses during preinit
Date:   Wed, 24 Jul 2019 21:20:36 +0200
Message-Id: <20190724191800.514334946@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 7cb95eeea6706c790571042a06782e378b2561ea upstream.

It turns out that while disabling i2c bus access from software when the
GPU is suspended was a step in the right direction with:

commit 342406e4fbba ("drm/nouveau/i2c: Disable i2c bus access after
->fini()")

We also ended up accidentally breaking the vbios init scripts on some
older Tesla GPUs, as apparently said scripts can actually use the i2c
bus. Since these scripts are executed before initializing any
subdevices, we end up failing to acquire access to the i2c bus which has
left a number of cards with their fan controllers uninitialized. Luckily
this doesn't break hardware - it just means the fan gets stuck at 100%.

This also means that we've always been using our i2c busses before
initializing them during the init scripts for older GPUs, we just didn't
notice it until we started preventing them from being used until init.
It's pretty impressive this never caused us any issues before!

So, fix this by initializing our i2c pad and busses during subdev
pre-init. We skip initializing aux busses during pre-init, as those are
guaranteed to only ever be used by nouveau for DP aux transactions.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Tested-by: Marc Meledandri <m.meledandri@gmail.com>
Fixes: 342406e4fbba ("drm/nouveau/i2c: Disable i2c bus access after ->fini()")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c
@@ -185,6 +185,25 @@ nvkm_i2c_fini(struct nvkm_subdev *subdev
 }
 
 static int
+nvkm_i2c_preinit(struct nvkm_subdev *subdev)
+{
+	struct nvkm_i2c *i2c = nvkm_i2c(subdev);
+	struct nvkm_i2c_bus *bus;
+	struct nvkm_i2c_pad *pad;
+
+	/*
+	 * We init our i2c busses as early as possible, since they may be
+	 * needed by the vbios init scripts on some cards
+	 */
+	list_for_each_entry(pad, &i2c->pad, head)
+		nvkm_i2c_pad_init(pad);
+	list_for_each_entry(bus, &i2c->bus, head)
+		nvkm_i2c_bus_init(bus);
+
+	return 0;
+}
+
+static int
 nvkm_i2c_init(struct nvkm_subdev *subdev)
 {
 	struct nvkm_i2c *i2c = nvkm_i2c(subdev);
@@ -238,6 +257,7 @@ nvkm_i2c_dtor(struct nvkm_subdev *subdev
 static const struct nvkm_subdev_func
 nvkm_i2c = {
 	.dtor = nvkm_i2c_dtor,
+	.preinit = nvkm_i2c_preinit,
 	.init = nvkm_i2c_init,
 	.fini = nvkm_i2c_fini,
 	.intr = nvkm_i2c_intr,


