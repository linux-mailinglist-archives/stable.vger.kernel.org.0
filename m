Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 283D4B5BDD
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfIRGUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbfIRGUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECE2121929;
        Wed, 18 Sep 2019 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787622;
        bh=KcAuGXcLMyibSCh9f3a5Nc0iP/gxhLJsrVubJb8eZT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGqZXIDojcdGmytbaW0D+MtcD0sCcyX/8fNWd57wIumVv4TpLzW1ZGi3AoXc1K9a1
         oktpHUN4RLp9nzf6NcQeAi2ldzA6XxaGnfNwr0rBiMDY5NKUPXFi8+SSQ0a1UZsJr5
         0pbZfGEEjT+8ivq3Fcz5KqgAHpaEtoaW9pJIwR2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.14 18/45] gpio: fix line flag validation in linehandle_create
Date:   Wed, 18 Sep 2019 08:18:56 +0200
Message-Id: <20190918061224.814891488@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
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
 drivers/gpio/gpiolib.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -444,12 +444,23 @@ static int linehandle_create(struct gpio
 	struct linehandle_state *lh;
 	struct file *file;
 	int fd, i, count = 0, ret;
+	u32 lflags;
 
 	if (copy_from_user(&handlereq, ip, sizeof(handlereq)))
 		return -EFAULT;
 	if ((handlereq.lines == 0) || (handlereq.lines > GPIOHANDLES_MAX))
 		return -EINVAL;
 
+	lflags = handlereq.flags;
+
+	/*
+	 * Do not allow both INPUT & OUTPUT flags to be set as they are
+	 * contradictory.
+	 */
+	if ((lflags & GPIOHANDLE_REQUEST_INPUT) &&
+	    (lflags & GPIOHANDLE_REQUEST_OUTPUT))
+		return -EINVAL;
+
 	lh = kzalloc(sizeof(*lh), GFP_KERNEL);
 	if (!lh)
 		return -ENOMEM;
@@ -470,7 +481,6 @@ static int linehandle_create(struct gpio
 	/* Request each GPIO */
 	for (i = 0; i < handlereq.lines; i++) {
 		u32 offset = handlereq.lineoffsets[i];
-		u32 lflags = handlereq.flags;
 		struct gpio_desc *desc;
 
 		if (offset >= gdev->ngpio) {


