Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F542CD70
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 19:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfE1RPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 13:15:50 -0400
Received: from www.linuxtv.org ([130.149.80.248]:49040 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfE1RPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 13:15:50 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hVfhT-0004ts-IW; Tue, 28 May 2019 17:15:47 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Tue, 28 May 2019 16:22:12 +0000
Subject: [git:media_tree/master] media: coda: Remove unbalanced and unneeded mutex unlock
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hVfhT-0004ts-IW@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: coda: Remove unbalanced and unneeded mutex unlock
Author:  Ezequiel Garcia <ezequiel@collabora.com>
Date:    Thu May 2 18:00:43 2019 -0400

The mutex unlock in the threaded interrupt handler is not paired
with any mutex lock. Remove it.

This bug has been here for a really long time, so it applies
to any stable repo.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/platform/coda/coda-bit.c | 1 -
 1 file changed, 1 deletion(-)

---

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index a25f3742ecde..19055c6488cc 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2348,7 +2348,6 @@ irqreturn_t coda_irq_handler(int irq, void *data)
 	if (ctx == NULL) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Instance released before the end of transaction\n");
-		mutex_unlock(&dev->coda_mutex);
 		return IRQ_HANDLED;
 	}
 
