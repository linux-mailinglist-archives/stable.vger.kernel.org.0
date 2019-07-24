Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AD174621
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391258AbfGYFo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391253AbfGYFoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:44:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A6922BF5;
        Thu, 25 Jul 2019 05:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033464;
        bh=AqHiGBYn3HleXsZMlRknDwFCCAMU0XQioeXh1aikw0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+tHN0OYoeQ/COtqsP5NV5jXluXvpIur1JliTgCrJUw45qaK8Pf3SQouL1T5hdxPe
         ON12kefUdrzhH0htONc4UY1VzbDBNQAx/ZjqNFdSig9k8g+A1toH6m8fJhUU6zllHK
         OSA3DkmVPSzDrgNZvyfPV15ue0c7j1gvvrzIGtD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 210/271] media: coda: Remove unbalanced and unneeded mutex unlock
Date:   Wed, 24 Jul 2019 21:21:19 +0200
Message-Id: <20190724191713.071665484@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

commit 766b9b168f6c75c350dd87c3e0bc6a9b322f0013 upstream.

The mutex unlock in the threaded interrupt handler is not paired
with any mutex lock. Remove it.

This bug has been here for a really long time, so it applies
to any stable repo.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/coda/coda-bit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2309,7 +2309,6 @@ irqreturn_t coda_irq_handler(int irq, vo
 	if (ctx == NULL) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Instance released before the end of transaction\n");
-		mutex_unlock(&dev->coda_mutex);
 		return IRQ_HANDLED;
 	}
 


