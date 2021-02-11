Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1635F318E66
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBKP0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhBKPJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:09:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4950A64EB9;
        Thu, 11 Feb 2021 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055812;
        bh=5bBAisnUx/EivRlInogrC4oMUh7HMDN3q0XuLUb/r04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s08laOSvDJQbzU6YqTegsipZtrwHl3jTBBAmk0fjeC4Ef1T+qdtIAFvawaSSa4tAj
         fYoLk8smYWbanrnz81bF2KygzLo6PWq2/+ao2gr82f3tf62Flje9h7mIESYmzD9Bbx
         GtAWmZ2q+463J6KBN5G/lvA/YHSdvC5QpMZKiYHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 17/54] gpiolib: cdev: clear debounce period if line set to output
Date:   Thu, 11 Feb 2021 16:02:01 +0100
Message-Id: <20210211150153.626682364@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Gibson <warthog618@gmail.com>

commit 03a58ea5905fdbd93ff9e52e670d802600ba38cd upstream.

When set_config changes a line from input to output debounce is
implicitly disabled, as debounce makes no sense for outputs, but the
debounce period is not being cleared and is still reported in the
line info.

So clear the debounce period when the debouncer is stopped in
edge_detector_stop().

Fixes: 65cff7046406 ("gpiolib: cdev: support setting debounce")
Cc: stable@vger.kernel.org
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -756,6 +756,8 @@ static void edge_detector_stop(struct li
 	cancel_delayed_work_sync(&line->work);
 	WRITE_ONCE(line->sw_debounced, 0);
 	line->eflags = 0;
+	if (line->desc)
+		WRITE_ONCE(line->desc->debounce_period_us, 0);
 	/* do not change line->level - see comment in debounced_value() */
 }
 


