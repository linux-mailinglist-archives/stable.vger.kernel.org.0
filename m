Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED96401BAD
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242515AbhIFM6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242552AbhIFM6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 208CB61027;
        Mon,  6 Sep 2021 12:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933036;
        bh=CYXxr/FbySZ3XmFuK5OlcLBmTFVKOYcNL84er3YjG+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV8UOSBxjjeKjYll+tsfX/Z1BSzgynQSiFgkB8p769nDFFlqwNuZkI5e768NRBtZO
         bp6yupsV8ckFJrJ1sCJR7VtyA3y+tghs6DPHmFwFLl3oJ3u88uimw+AcvRvOLWgxmw
         CBuwIixzEGK39iaRDgFxbft1s8QmMMeKwCUGRIMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 26/29] spi: Switch to signed types for *_native_cs SPI controller fields
Date:   Mon,  6 Sep 2021 14:55:41 +0200
Message-Id: <20210906125450.652822168@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 35f3f8504c3b60a1ae5576e178b27fc0ddd6157d upstream.

While fixing undefined behaviour the commit f60d7270c8a3 ("spi: Avoid
undefined behaviour when counting unused native CSs") missed the case
when all CSs are GPIOs and thus unused_native_cs will be evaluated to
-1 in unsigned representation. This will falsely trigger a condition
in the spi_get_gpio_descs().

Switch to signed types for *_native_cs SPI controller fields to fix above.

Fixes: f60d7270c8a3 ("spi: Avoid undefined behaviour when counting unused native CSs")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210510131242.49455-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/spi/spi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -646,8 +646,8 @@ struct spi_controller {
 	int			*cs_gpios;
 	struct gpio_desc	**cs_gpiods;
 	bool			use_gpio_descriptors;
-	u8			unused_native_cs;
-	u8			max_native_cs;
+	s8			unused_native_cs;
+	s8			max_native_cs;
 
 	/* statistics */
 	struct spi_statistics	statistics;


