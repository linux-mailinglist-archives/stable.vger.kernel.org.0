Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC1069CD1A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjBTNqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjBTNqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA9A1E1EE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:46:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1190B80D4C
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD702C433D2;
        Mon, 20 Feb 2023 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900765;
        bh=Y3ihDVjHnsXppxwMHisRMJ3klKEC82lDmX3O7DPxAe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsQwTHsE9EsxDnxzantbemd9FaaxhQ4NxzJE7koqNAx7yrmlo8WNz26XKWqBT8HAd
         F9ntWqJdSAgBxZsHpIgCtWhE4r20qUMgL4WEk1ajsl2HWbb0StELYQ2PSaSJAcgk/6
         1my8S4DEcEvOpSGBCg6dGhunmw8TDdJcovpxFNkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Andreas Kemnade <andreas@kemnade.info>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/156] iio:adc:twl6030: Enable measurement of VAC
Date:   Mon, 20 Feb 2023 14:35:03 +0100
Message-Id: <20230220133604.800520159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit bffb7d9d1a3dbd09e083b88aefd093b3b10abbfb ]

VAC needs to be wired up to produce proper measurements,
without this change only near zero values are reported.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Fixes: 1696f36482e7 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221217221305.671117-1-andreas@kemnade.info
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/twl6030-gpadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index 845e994e113ec..0a76081747580 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -952,7 +952,7 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	}
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
-				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				VBAT_MEAS | BB_MEAS | VAC_MEAS,
 				TWL6030_MISC1);
 	if (ret < 0) {
 		dev_err(dev, "failed to wire up inputs\n");
-- 
2.39.0



