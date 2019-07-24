Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EA173E95
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388607AbfGXUZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389739AbfGXTi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3030E229F4;
        Wed, 24 Jul 2019 19:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997107;
        bh=rS0zYdFdtQ7G+JZz57Aeqv6qwSj0FtXQQ8hJ4e/VJ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KH7pH/1egggLJGR3EJO7cqFy4LQcLzM4RGaoc201tiNcnQ+ZX4Z2a5/Sgj0RwTKv3
         h3NJNVgErSzpNzyoCABPyJZXodpDfHxDMuK3NvF/nSs9KtcP29d0TerJcNFvE2o7ry
         g8pcT4vFZQPlvU/rvQkSdym8+fxdhQbywbc8fXmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.2 323/413] media: coda: Remove unbalanced and unneeded mutex unlock
Date:   Wed, 24 Jul 2019 21:20:14 +0200
Message-Id: <20190724191758.984113359@linuxfoundation.org>
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
@@ -2310,7 +2310,6 @@ irqreturn_t coda_irq_handler(int irq, vo
 	if (ctx == NULL) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Instance released before the end of transaction\n");
-		mutex_unlock(&dev->coda_mutex);
 		return IRQ_HANDLED;
 	}
 


