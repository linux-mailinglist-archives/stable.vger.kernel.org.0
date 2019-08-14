Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB58D8C9
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfHNRCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbfHNRCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56F4021721;
        Wed, 14 Aug 2019 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802142;
        bh=U9GZybwqBMTNczE3+A/N7gO5fjolwAGt4+mAUY4dWGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKuaHVsMuhjfsWcq7gXDwNBjuJbLgzNi+UK+55/MfGlIB6JDNyHne/FgJECHCAnEn
         X2OnYWmfuCIEMED4lJPiyl/WAvxhpy1NuzMkQHzUGKBE/tZCYGKbYbgZQghFxpuE2T
         7v7bHDWdHOmJp0cHQ932V/FPh69AG2otN4GP7m1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.net>,
        Phil Reid <preid@electromag.com.au>
Subject: [PATCH 5.2 011/144] Staging: fbtft: Fix reset assertion when using gpio descriptor
Date:   Wed, 14 Aug 2019 18:59:27 +0200
Message-Id: <20190814165800.271540637@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Reid <preid@electromag.com.au>

commit b918d1c2706619cb0712a61cc8c05148b68b24b2 upstream.

Typically gpiod_set_value calls would assert the reset line and
then release it using the symantics of:
	gpiod_set_value(par->gpio.reset, 0);
	... delay
	gpiod_set_value(par->gpio.reset, 1);
And the gpio binding would specify the polarity.

Prior to conversion to gpiod calls the polarity in the DT
was ignored and assumed to be active low. Fix it so that
DT polarity is respected.

Fixes: c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor interface")
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jan Sebastian Götte <linux@jaseg.net>
Signed-off-by: Phil Reid <preid@electromag.com.au>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1563236677-5045-3-git-send-email-preid@electromag.com.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/fbtft/fbtft-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -231,9 +231,9 @@ static void fbtft_reset(struct fbtft_par
 	if (!par->gpio.reset)
 		return;
 	fbtft_par_dbg(DEBUG_RESET, par, "%s()\n", __func__);
-	gpiod_set_value_cansleep(par->gpio.reset, 0);
-	usleep_range(20, 40);
 	gpiod_set_value_cansleep(par->gpio.reset, 1);
+	usleep_range(20, 40);
+	gpiod_set_value_cansleep(par->gpio.reset, 0);
 	msleep(120);
 }
 


