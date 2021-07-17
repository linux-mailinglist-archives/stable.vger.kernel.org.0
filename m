Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA2F3CC126
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 06:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhGQEfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 00:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhGQEfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 00:35:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9184C06175F;
        Fri, 16 Jul 2021 21:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=tPPyY5MBjKqNHGlTzJZpE7448Byrjeik476m/6siGKA=; b=0FffkiGFJJppGoktqgocJi2TLj
        I7bUkxGXNKDjQrWzK5IED6M+3FPID9i+4gWZi1NzabTujDc6wGSFZz4RDrhfg1GlopUQv452nqV3d
        /KafKuB3WbG2zYsUcwsZcKuwSXZJZ2gZ2o5Qjbj4UIH6oP6ebb0qET/fE+hdIVgq4tWCmvQwY4rxl
        gdXqmdo2q2KqiDpKRiE9S3G+7+DyE1bvz03qHjkVmj0iCBtUExUL3I40AViKGk0MiNIErdiMnLfAe
        91JypbL04TWTLhix880JjxkTTPY2IvpvqGNibHTP/NWsEnQQ8U8os/IBIn6SF0RRVhZFaco1Z1AWj
        s/9r/39A==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4bzc-005vYC-7V; Sat, 17 Jul 2021 04:32:00 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Dongjiu Geng <gengdongjiu@huawei.com>,
        Stephen Boyd <sboyd@kernel.org>, stable@vger.kernel.org,
        linux-clk@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>
Subject: [PATCH] clk: hisilicon: hi3559a: select RESET_HISI
Date:   Fri, 16 Jul 2021 21:31:59 -0700
Message-Id: <20210717043159.12566-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The clk-hi3559a driver uses functions from reset.c so it should
select RESET_HISI to avoid build errors.

Fixes these build errors:
aarch64-linux-ld: drivers/clk/hisilicon/clk-hi3559a.o: in function `hi3559av100_crg_remove':
clk-hi3559a.c:(.text+0x158): undefined reference to `hisi_reset_exit'
aarch64-linux-ld: drivers/clk/hisilicon/clk-hi3559a.o: in function `hi3559av100_crg_probe':
clk-hi3559a.c:(.text+0x1f4): undefined reference to `hisi_reset_init'
aarch64-linux-ld: clk-hi3559a.c:(.text+0x238): undefined reference to `hisi_reset_exit'

Fixes: 6c81966107dc ("clk: hisilicon: Add clock driver for hi3559A SoC")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: Michael Turquette <mturquette@baylibre.com>
---
 drivers/clk/hisilicon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210716.orig/drivers/clk/hisilicon/Kconfig
+++ linux-next-20210716/drivers/clk/hisilicon/Kconfig
@@ -18,6 +18,7 @@ config COMMON_CLK_HI3519
 config COMMON_CLK_HI3559A
 	bool "Hi3559A Clock Driver"
 	depends on ARCH_HISI || COMPILE_TEST
+	select RESET_HISI
 	default ARCH_HISI
 	help
 	  Build the clock driver for hi3559a.
