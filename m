Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E7D283AC1
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgJEPgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgJEPcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D31ED21527;
        Mon,  5 Oct 2020 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911950;
        bh=GapCIPvOXQn9bnU5or2XP8SvGxe9v4ZfuP0qGqsqjqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gj9w1KJMVjW/kXLwvhetbcdoeAXpFg5q6JQkAPYfzNYMx9AVIg821hlC6XCMuvr4u
         jnHEk3T89mF6p/XEPabo8GAhPqhi+kOmLI1MOFPwFdr4U8LVxfZSUB6WCMDBFxRVba
         pTFDYcofkbyGV2JyPlkoSorE1T6huHJkbR68rIAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ed Wildgoose <lists@wildgooses.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.8 12/85] gpio: amd-fch: correct logic of GPIO_LINE_DIRECTION
Date:   Mon,  5 Oct 2020 17:26:08 +0200
Message-Id: <20201005142115.326894667@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ed Wildgoose <lists@wildgooses.com>

commit d25e8fdebdad84219b498873300b7f11dd915b88 upstream.

The original commit appears to have the logic reversed in
amd_fch_gpio_get_direction. Also confirmed by observing the value of
"direction" in the sys tree.

Signed-off-by: Ed Wildgoose <lists@wildgooses.com>
Fixes: e09d168f13f0 ("gpio: AMD G-Series PCH gpio driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-amd-fch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-amd-fch.c
+++ b/drivers/gpio/gpio-amd-fch.c
@@ -92,7 +92,7 @@ static int amd_fch_gpio_get_direction(st
 	ret = (readl_relaxed(ptr) & AMD_FCH_GPIO_FLAG_DIRECTION);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return ret ? GPIO_LINE_DIRECTION_IN : GPIO_LINE_DIRECTION_OUT;
+	return ret ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
 }
 
 static void amd_fch_gpio_set(struct gpio_chip *gc,


