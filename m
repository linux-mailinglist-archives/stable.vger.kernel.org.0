Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599F33A6351
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhFNLL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235357AbhFNLJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B657361456;
        Mon, 14 Jun 2021 10:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667617;
        bh=maORWLPVrr9ivQoLTNE0VfpAaNk2Qk2q3HQkmhtjt/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIDRI37H9S1XE3aQ72WyhL3YZJppW3i2+RLmj9Bfc6Q78xIUWopzbFFGH75+yghl6
         wa26CX1bgl63uAQJp67GCjIiauUNgX9YNQD68dG7YS6Hw6AB69yIv63ROO/Q8tUTo+
         XzoOgHO8MzIVTyUXgn4GYMGy9e1QC/5PRWTlNYak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 112/131] gpio: wcd934x: Fix shift-out-of-bounds error
Date:   Mon, 14 Jun 2021 12:27:53 +0200
Message-Id: <20210614102656.812266049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit dbec64b11c65d74f31427e2b9d5746fbf17bf840 upstream.

bit-mask for pins 0 to 4 is BIT(0) to BIT(4) however we ended up with BIT(n - 1)
which is not right, and this was caught by below usban check

UBSAN: shift-out-of-bounds in drivers/gpio/gpio-wcd934x.c:34:14

Fixes: 59c324683400 ("gpio: wcd934x: Add support to wcd934x gpio controller")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-wcd934x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -7,7 +7,7 @@
 #include <linux/slab.h>
 #include <linux/of_device.h>
 
-#define WCD_PIN_MASK(p) BIT(p - 1)
+#define WCD_PIN_MASK(p) BIT(p)
 #define WCD_REG_DIR_CTL_OFFSET 0x42
 #define WCD_REG_VAL_CTL_OFFSET 0x43
 #define WCD934X_NPINS		5


