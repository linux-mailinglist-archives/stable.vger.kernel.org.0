Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC86BB5CD0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbfIRGZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728817AbfIRGY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C5121925;
        Wed, 18 Sep 2019 06:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787898;
        bh=OiFWf4eOdlYnzji0Ydxi9BHjYxXgfE1aWMbf64l7xUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrmrDo9QcBKXUkQxLJIoMdQ6lZ+OchyBnFKOgcF4eBPmRaJO/3nLyjJ2FjG8CZSbj
         cgDuaYJoNuc8lywFnaaz/w/KmQ7NV6iDcYVflZqKyNPMXQUd4N/Q1FJbXfMa5ZDayW
         uVMxHI8WcT0IFh5x5o0vS1yCoJ8SjR/OakqWVllA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.2 24/85] gpio: fix line flag validation in linehandle_create
Date:   Wed, 18 Sep 2019 08:18:42 +0200
Message-Id: <20190918061234.924147200@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
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
@@ -536,6 +536,14 @@ static int linehandle_create(struct gpio
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


