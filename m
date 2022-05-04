Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6151A8CF
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355849AbiEDRMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356902AbiEDRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A24705E;
        Wed,  4 May 2022 09:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76696B8278E;
        Wed,  4 May 2022 16:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D118C385AA;
        Wed,  4 May 2022 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683379;
        bh=ONBYb8v121brOkOd1ch+d7ogP3JcBfcYrRpecypHYpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLUxCiQtZ51rkeQvz4AYJ1XY4S2IScR1LyaH51gtEg2wzHxprOHhZuNs2OT3/IxRu
         I4rwbT4H2JVfXC5sj9FIXv1dLgFG2tklzkusngHZljfjK7WrYBoFHVrp1ytZIZpk3U
         R3zXEHbRloN1Mtnc+9qfC4Y9t65mD4xrG0eunQEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 064/225] iio:filter:admv8818: select REGMAP_SPI for ADMV8818
Date:   Wed,  4 May 2022 18:45:02 +0200
Message-Id: <20220504153115.890991921@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit d85cce86a86746354fffb688dd134609c8277adc ]

admv8818 driver needs __devm_regmap_init_spi() which is defined
when CONFIG_REGMAP_SPI is set and struct regmap_config when
CONFIG_REGMAP is set, so automatically select CONFIG_REGMAP_SPI
which also sets CONFIG_REGMAP.

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220320055457.254983-1-bobo.shaobowang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/filter/Kconfig b/drivers/iio/filter/Kconfig
index 3ae35817ad82..a85b345ea14e 100644
--- a/drivers/iio/filter/Kconfig
+++ b/drivers/iio/filter/Kconfig
@@ -8,6 +8,7 @@ menu "Filters"
 config ADMV8818
 	tristate "Analog Devices ADMV8818 High-Pass and Low-Pass Filter"
 	depends on SPI && COMMON_CLK && 64BIT
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices ADMV8818
 	  2 GHz to 18 GHz, Digitally Tunable, High-Pass and Low-Pass Filter.
-- 
2.35.1



