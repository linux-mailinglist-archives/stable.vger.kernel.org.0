Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5272266AE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbgGTQFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbgGTQFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A393B206E9;
        Mon, 20 Jul 2020 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261118;
        bh=vLX9FaXwbX361xZKoxrNQ5wbHdFNkfiK2AFD3ea92PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sus9yuXbuFXdJ+CCicfgw6dY7fj+pizYCl2g75MLyz+xakAU0sHvDhYgxoxo4OUiU
         5/iPEK2MW1RBFjmQJmJwShqkm4Qm9x+RiOFpNJvHFySCHorohSSr5bPPTkaml8rDTc
         jglM2gN5aHrNI8mhvoAUDJ4LmSBjC7OHDXuM7wjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 215/215] gpio: pca953x: disable regmap locking for automatic address incrementing
Date:   Mon, 20 Jul 2020 17:38:17 +0200
Message-Id: <20200720152830.376869792@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit ec3decd21380081e3b5de4ba8d85d90a95f201a0 upstream.

It's a repetition of the commit aa58a21ae378
  ("gpio: pca953x: disable regmap locking")
which states the following:

  This driver uses its own locking but regmap silently uses
  a mutex for all operations too. Add the option to disable
  locking to the regmap config struct.

Fixes: bcf41dc480b1 ("gpio: pca953x: fix handling of automatic address incrementing")
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-pca953x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -398,6 +398,7 @@ static const struct regmap_config pca953
 	.writeable_reg = pca953x_writeable_register,
 	.volatile_reg = pca953x_volatile_register,
 
+	.disable_locking = true,
 	.cache_type = REGCACHE_RBTREE,
 	.max_register = 0x7f,
 };


