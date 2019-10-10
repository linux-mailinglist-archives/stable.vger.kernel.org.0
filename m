Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B06D262B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbfJJJUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUx (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C5B20B7C;
        Thu, 10 Oct 2019 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699252;
        bh=2XZb+L176nC6S8YO49zjUDlVKC4N7LSbDGSYXqvJRh0=;
        h=Subject:To:From:Date:From;
        b=koCLgVTwupu41y8Fok5HAbhcb9XYUIZrMbsIm5Qc83fX++IwTMaSJEXFXKb6b6uX+
         QVcBFKId7mmdV1TNpmMPE3j91eOrDS5E/l8o4SpclL75KWzz3Tq0L3J3YIu9gVbhA0
         LTHdFIOt7gQ6iTxSxnZGb928anI5ruheBFKew9tk=
Subject: patch "iio: light: opt3001: fix mutex unlock race" added to staging-linus
To:     dpfrey@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, dannenberg@ti.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:09 +0200
Message-ID: <157069920924250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: opt3001: fix mutex unlock race

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 82f3015635249a8c8c45bac303fd84905066f04f Mon Sep 17 00:00:00 2001
From: David Frey <dpfrey@gmail.com>
Date: Thu, 19 Sep 2019 15:54:18 -0700
Subject: iio: light: opt3001: fix mutex unlock race

When an end-of-conversion interrupt is received after performing a
single-shot reading of the light sensor, the driver was waking up the
result ready queue before checking opt->ok_to_ignore_lock to determine
if it should unlock the mutex. The problem occurred in the case where
the other thread woke up and changed the value of opt->ok_to_ignore_lock
to false prior to the interrupt thread performing its read of the
variable. In this case, the mutex would be unlocked twice.

Signed-off-by: David Frey <dpfrey@gmail.com>
Reviewed-by: Andreas Dannenberg <dannenberg@ti.com>
Fixes: 94a9b7b1809f ("iio: light: add support for TI's opt3001 light sensor")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/opt3001.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/opt3001.c b/drivers/iio/light/opt3001.c
index e666879007d2..92004a2563ea 100644
--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -686,6 +686,7 @@ static irqreturn_t opt3001_irq(int irq, void *_iio)
 	struct iio_dev *iio = _iio;
 	struct opt3001 *opt = iio_priv(iio);
 	int ret;
+	bool wake_result_ready_queue = false;
 
 	if (!opt->ok_to_ignore_lock)
 		mutex_lock(&opt->lock);
@@ -720,13 +721,16 @@ static irqreturn_t opt3001_irq(int irq, void *_iio)
 		}
 		opt->result = ret;
 		opt->result_ready = true;
-		wake_up(&opt->result_ready_queue);
+		wake_result_ready_queue = true;
 	}
 
 out:
 	if (!opt->ok_to_ignore_lock)
 		mutex_unlock(&opt->lock);
 
+	if (wake_result_ready_queue)
+		wake_up(&opt->result_ready_queue);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.23.0


