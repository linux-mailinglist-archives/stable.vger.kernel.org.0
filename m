Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E7DA133
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392941AbfJPWUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437570AbfJPVxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:44 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FDD21928;
        Wed, 16 Oct 2019 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262823;
        bh=cTL+dBjDCxL6Y0uF6sd753LlF0axEe9XOYq7JAgM1hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4QK6at8mdaXPkwPaqrJv4gWlaWDK+2e9+JWfTSjlsar3VBeeM8pcrPq4+dsXGRKm
         dinU6uR3WkkmmwWdeG20Nk1UP+S44Jt5GS85XlvkadhPIej4wOrtTfnXDtOgMfsHdR
         g2ydEza1GoXBY5Pqn7Szu1hus9eRfz3/Pp9IXt0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Frey <dpfrey@gmail.com>,
        Andreas Dannenberg <dannenberg@ti.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.4 66/79] iio: light: opt3001: fix mutex unlock race
Date:   Wed, 16 Oct 2019 14:50:41 -0700
Message-Id: <20191016214826.651806493@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
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
@@ -646,6 +646,7 @@ static irqreturn_t opt3001_irq(int irq,
 	struct iio_dev *iio = _iio;
 	struct opt3001 *opt = iio_priv(iio);
 	int ret;
+	bool wake_result_ready_queue = false;
 
 	if (!opt->ok_to_ignore_lock)
 		mutex_lock(&opt->lock);
@@ -680,13 +681,16 @@ static irqreturn_t opt3001_irq(int irq,
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
 


