Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD155D93B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbiF0Lxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiF0LvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7915D65C1;
        Mon, 27 Jun 2022 04:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB44261150;
        Mon, 27 Jun 2022 11:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B82C3411D;
        Mon, 27 Jun 2022 11:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330271;
        bh=s2PJ6AvPvEed3uDSlF+Egx5Za1Gv+BMJQwt6EC4A4NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAP9AnoPc4g9HsXgu9UEuEgXcjy3CdIHnZ0AhIXBP3TMlRZ1ygqbuPkDVSm2pzlBx
         uXQT1qsicTtc3hiauEeKI562X96l6oST6wg/aBraQyPsjRtu1F/XyVITN6a1ZhH65M
         nyiMl+ddYOqXWAtukj53gtgtIgQtHFyDYv5Ctxk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Liam Beguin <liambeguin@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 142/181] iio: test: fix missing MODULE_LICENSE for IIO_RESCALE=m
Date:   Mon, 27 Jun 2022 13:21:55 +0200
Message-Id: <20220627111948.803931529@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Beguin <liambeguin@gmail.com>

commit 7a2f6f61e8ee016b75e1b1dd62fbd03e6d6db37d upstream.

When IIO_RESCALE_KUNIT_TEST=y and IIO_RESCALE=m,
drivers/iio/afe/iio-rescale.o is built twice causing the
MODULE_LICENSE() to be lost, as shown by:

  ERROR: modpost: missing MODULE_LICENSE() in drivers/iio/afe/iio-rescale.o

Rework the build configuration to have the dependency specified in the
Kconfig.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 8e74a48d17d5 ("iio: test: add basic tests for the iio-rescale driver")
Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20220601142138.3331278-1-liambeguin@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/test/Kconfig  | 2 +-
 drivers/iio/test/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/test/Kconfig b/drivers/iio/test/Kconfig
index 56ca0ad7e77a..4c66c3f18c34 100644
--- a/drivers/iio/test/Kconfig
+++ b/drivers/iio/test/Kconfig
@@ -6,7 +6,7 @@
 # Keep in alphabetical order
 config IIO_RESCALE_KUNIT_TEST
 	bool "Test IIO rescale conversion functions"
-	depends on KUNIT=y && !IIO_RESCALE
+	depends on KUNIT=y && IIO_RESCALE=y
 	default KUNIT_ALL_TESTS
 	help
 	  If you want to run tests on the iio-rescale code say Y here.
diff --git a/drivers/iio/test/Makefile b/drivers/iio/test/Makefile
index f15ae0a6394f..880360f8d02c 100644
--- a/drivers/iio/test/Makefile
+++ b/drivers/iio/test/Makefile
@@ -4,6 +4,6 @@
 #
 
 # Keep in alphabetical order
-obj-$(CONFIG_IIO_RESCALE_KUNIT_TEST) += iio-test-rescale.o ../afe/iio-rescale.o
+obj-$(CONFIG_IIO_RESCALE_KUNIT_TEST) += iio-test-rescale.o
 obj-$(CONFIG_IIO_TEST_FORMAT) += iio-test-format.o
 CFLAGS_iio-test-format.o += $(DISABLE_STRUCTLEAK_PLUGIN)
-- 
2.36.1



