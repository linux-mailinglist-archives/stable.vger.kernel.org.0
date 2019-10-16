Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AAED9FE7
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392448AbfJPWFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438239AbfJPV6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:43 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D95521928;
        Wed, 16 Oct 2019 21:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263122;
        bh=HIAuGaaioLIQFgy5x+2q4gdqBHXPwkNmZcHznQAe/0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEvyWr0eUx7jxh9GpqzRnsDni/pYf4LE8kmtKTSK/IUxuJe6tl7q1IbHZ9jq/3gYk
         lLpomtRZAjg7io1/Qh2gZJ1X/2kGnweK2wXNM5kZzFGk8+wyatsLK0E3j+0gh1p53j
         E5MREIqOqQiyaMf2gXtkyFtyLcjn4rZ5It+AMU1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Chen <bruce.chen@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.3 046/112] gpio: eic: sprd: Fix the incorrect EIC offset when toggling
Date:   Wed, 16 Oct 2019 14:50:38 -0700
Message-Id: <20191016214855.052818171@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruce Chen <bruce.chen@unisoc.com>

commit e91aafcb51f3c5001ae76c3ee027beb0b8506447 upstream.

When toggling the level trigger to emulate the edge trigger, the
EIC offset is incorrect without adding the corresponding bank index,
thus fix it.

Fixes: 7bf0d7f62282 ("gpio: eic: Add edge trigger emulation for EIC")
Cc: stable@vger.kernel.org
Signed-off-by: Bruce Chen <bruce.chen@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-eic-sprd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-eic-sprd.c
+++ b/drivers/gpio/gpio-eic-sprd.c
@@ -530,11 +530,12 @@ static void sprd_eic_handle_one_type(str
 		}
 
 		for_each_set_bit(n, &reg, SPRD_EIC_PER_BANK_NR) {
-			girq = irq_find_mapping(chip->irq.domain,
-					bank * SPRD_EIC_PER_BANK_NR + n);
+			u32 offset = bank * SPRD_EIC_PER_BANK_NR + n;
+
+			girq = irq_find_mapping(chip->irq.domain, offset);
 
 			generic_handle_irq(girq);
-			sprd_eic_toggle_trigger(chip, girq, n);
+			sprd_eic_toggle_trigger(chip, girq, offset);
 		}
 	}
 }


