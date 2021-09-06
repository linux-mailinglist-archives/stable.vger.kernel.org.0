Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2796F40162F
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 08:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhIFGJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 02:09:52 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:45236 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhIFGJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 02:09:52 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 18668lGm003000; Mon, 6 Sep 2021 15:08:47 +0900
X-Iguazu-Qid: 34trwupu8pSpI0BPYv
X-Iguazu-QSIG: v=2; s=0; t=1630908527; q=34trwupu8pSpI0BPYv; m=wGUJhJtqrY6jdX2BAf9GJiElGYRVA9MMB7pS17ADSrU=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1510) id 18668k9p026036
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 6 Sep 2021 15:08:46 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id B48F01000D2
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 15:08:46 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 18668kYq020581
        for <stable@vger.kernel.org>; Mon, 6 Sep 2021 15:08:46 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 5.10.y] spi: Switch to signed types for *_native_cs SPI controller fields
Date:   Mon,  6 Sep 2021 15:08:42 +0900
X-TSB-HOP: ON
Message-Id: <20210906060842.2913612-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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
---
 include/linux/spi/spi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 2d906b9c149929..e1d88630ff2439 100644
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
-- 
2.33.0


