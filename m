Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C476358DC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbiKWKEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiKWKCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:02:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBBCE9302
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F8361B5F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1BFC433D6;
        Wed, 23 Nov 2022 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197274;
        bh=xHDR+dG8nl0mSjuWI4uVWoZwZCT7PEp/mGc7sjvlfJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPTWygkbahz4lTMQ5RytJQsVlKy+q49jRx/fiw9f1OLZ1X3RNKl4CBZdN8ryGt5W+
         mBugObb26HX+XjEX39xPO3JC/F8Wmtl5YDBcgFBwDu23fKGj7HbnuqY0cCk/MYd1MP
         k3iyDQRwQPwbjeqzsb/UwsbIZ0EHwpngF1CNwlCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saravanan Sekar <sravanhome@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 248/314] iio: adc: mp2629: fix potential array out of bound access
Date:   Wed, 23 Nov 2022 09:51:33 +0100
Message-Id: <20221123084636.749533707@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Saravanan Sekar <sravanhome@gmail.com>

commit ca1547ab15f48dc81624183ae17a2fd1bad06dfc upstream.

Add sentinel at end of maps to avoid potential array out of
bound access in iio core.

Fixes: 7abd9fb64682 ("iio: adc: mp2629: Add support for mp2629 ADC driver")
Signed-off-by: Saravanan Sekar <sravanhome@gmail.com>
Link: https://lore.kernel.org/r/20221029093000.45451-4-sravanhome@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/mp2629_adc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/mp2629_adc.c
+++ b/drivers/iio/adc/mp2629_adc.c
@@ -57,7 +57,8 @@ static struct iio_map mp2629_adc_maps[]
 	MP2629_MAP(SYSTEM_VOLT, "system-volt"),
 	MP2629_MAP(INPUT_VOLT, "input-volt"),
 	MP2629_MAP(BATT_CURRENT, "batt-current"),
-	MP2629_MAP(INPUT_CURRENT, "input-current")
+	MP2629_MAP(INPUT_CURRENT, "input-current"),
+	{ }
 };
 
 static int mp2629_read_raw(struct iio_dev *indio_dev,


