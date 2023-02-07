Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1212468D915
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjBGNPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjBGNPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:15:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1066F3BD8B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A2CB81989
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F39C433EF;
        Tue,  7 Feb 2023 13:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775688;
        bh=gKicsm884fVtGi7zTizv8eQmzZhVm3Sm/SkejxI0+Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoMilXAYaC0/5do9GfdJWn++s3i5kxuV0S6aMtcaiaWYWVS7CWyM/tbuk4IGpchjE
         pdjZYdVqG2Pjog27ZKvFq8mfW+6t1D2OurdTISVy2H6tf8XYPYQPYjPUMHcTYVMuM/
         Zds/b2VpxzHWe2fK46hpAPkKnlq6QFqdUkHdtulw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Andreas Kemnade <andreas@kemnade.info>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 111/120] iio:adc:twl6030: Enable measurement of VAC
Date:   Tue,  7 Feb 2023 13:58:02 +0100
Message-Id: <20230207125623.504648931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

commit bffb7d9d1a3dbd09e083b88aefd093b3b10abbfb upstream.

VAC needs to be wired up to produce proper measurements,
without this change only near zero values are reported.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Fixes: 1696f36482e7 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221217221305.671117-1-andreas@kemnade.info
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/twl6030-gpadc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -952,7 +952,7 @@ static int twl6030_gpadc_probe(struct pl
 	}
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
-				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				VBAT_MEAS | BB_MEAS | VAC_MEAS,
 				TWL6030_MISC1);
 	if (ret < 0) {
 		dev_err(dev, "failed to wire up inputs\n");


