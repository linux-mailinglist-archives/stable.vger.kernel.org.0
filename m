Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB28420E11
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhJDNVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236281AbhJDNTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:19:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F254961B4C;
        Mon,  4 Oct 2021 13:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352903;
        bh=f+RVrChlJbZiy19Yzza0vWnEE1JmBAjCu8medznn+eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiGjAstDxqUKWmCY+LdL0h9Gje/kKK0vC2Tya2pz2UPr8GInuYQjQ96I1perKzBcd
         ShEDfOCDSG5poy1fj8ZuAU8MaThqmEsAJQIh3DJJtyCusV1krhZKxW/80sIueO5L3Y
         IaNDztWycGi1vbNFQsIUY3XWK9r0ybQewMI5BwJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.10 13/93] gpio: pca953x: do not ignore i2c errors
Date:   Mon,  4 Oct 2021 14:52:11 +0200
Message-Id: <20211004125035.016468268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Gusakov <andrey.gusakov@cogentembedded.com>

commit 540cffbab8b8e6c52a4121666ca18d6e94586ed2 upstream.

Per gpio_chip interface, error shall be proparated to the caller.

Attempt to silent diagnostics by returning zero (as written in the
comment) is plain wrong, because the zero return can be interpreted by
the caller as the gpio value.

Cc: stable@vger.kernel.org
Signed-off-by: Andrey Gusakov <andrey.gusakov@cogentembedded.com>
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -467,15 +467,8 @@ static int pca953x_gpio_get_value(struct
 	mutex_lock(&chip->i2c_lock);
 	ret = regmap_read(chip->regmap, inreg, &reg_val);
 	mutex_unlock(&chip->i2c_lock);
-	if (ret < 0) {
-		/*
-		 * NOTE:
-		 * diagnostic already emitted; that's all we should
-		 * do unless gpio_*_value_cansleep() calls become different
-		 * from their nonsleeping siblings (and report faults).
-		 */
-		return 0;
-	}
+	if (ret < 0)
+		return ret;
 
 	return !!(reg_val & bit);
 }


