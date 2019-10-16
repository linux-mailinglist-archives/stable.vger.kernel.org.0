Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D83CD9F9C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395412AbfJPV4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390510AbfJPV4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:42 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 744D621D7A;
        Wed, 16 Oct 2019 21:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263001;
        bh=AyP47DE0aOW3YdRHBv28szmli6vQ7mQ8OQ0KpvCpmzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgnpMCiZsrQXwmpmYnXjhUluIYGv9F1z8EhJpjT9GT6DqMcHNibDZFxqu7BbnDrYp
         S5wbKAg/STipsMW80bmPHMCZep69AU5uEGTOmdzldsDruJoFvFI/PfSPRZVLhBp2SS
         U9OfNolwCpu827wWyqHnVgo2xmjcn3ZZh2ta7GrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Frey <dpfrey@gmail.com>,
        Andreas Dannenberg <dannenberg@ti.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 42/65] iio: light: opt3001: fix mutex unlock race
Date:   Wed, 16 Oct 2019 14:50:56 -0700
Message-Id: <20191016214832.459532926@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Frey <dpfrey@gmail.com>

commit 82f3015635249a8c8c45bac303fd84905066f04f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/opt3001.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -695,6 +695,7 @@ static irqreturn_t opt3001_irq(int irq,
 	struct iio_dev *iio = _iio;
 	struct opt3001 *opt = iio_priv(iio);
 	int ret;
+	bool wake_result_ready_queue = false;
 
 	if (!opt->ok_to_ignore_lock)
 		mutex_lock(&opt->lock);
@@ -729,13 +730,16 @@ static irqreturn_t opt3001_irq(int irq,
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
 


