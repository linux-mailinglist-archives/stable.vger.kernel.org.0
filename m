Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE440B5C11
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfIRGW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbfIRGWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:22:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE8D21A4C;
        Wed, 18 Sep 2019 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787741;
        bh=E5qFM9JwfT/RlEFz5qXENUWs6QlfF4J6VVbZoYTgojM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZX39OUdMG4AWaMDA6Lu42fEP5fCkx4DGdKuUeqIP4oCSS5KeDRPza4vxsWusjkFV
         tX6Y75lnOB+ZYvRJ7LtEHiuWm3ZnbWEtuZwD4t2ppQ65Vro4AyVlVDe7UrEQ4HPQF9
         /VaDCl7SlJawMW2YjHesA+UrggbvZEHXyR4Z9yaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.19 17/50] gpio: fix line flag validation in linehandle_create
Date:   Wed, 18 Sep 2019 08:19:00 +0200
Message-Id: <20190918061224.818165049@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Gibson <warthog618@gmail.com>

commit e95fbc130a162ba9ad956311b95aa0da269eea48 upstream.

linehandle_create should not allow both GPIOHANDLE_REQUEST_INPUT
and GPIOHANDLE_REQUEST_OUTPUT to be set.

Fixes: d7c51b47ac11 ("gpio: userspace ABI for reading/writing GPIO lines")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -525,6 +525,14 @@ static int linehandle_create(struct gpio
 		return -EINVAL;
 
 	/*
+	 * Do not allow both INPUT & OUTPUT flags to be set as they are
+	 * contradictory.
+	 */
+	if ((lflags & GPIOHANDLE_REQUEST_INPUT) &&
+	    (lflags & GPIOHANDLE_REQUEST_OUTPUT))
+		return -EINVAL;
+
+	/*
 	 * Do not allow OPEN_SOURCE & OPEN_DRAIN flags in a single request. If
 	 * the hardware actually supports enabling both at the same time the
 	 * electrical result would be disastrous.


