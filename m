Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42728658500
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbiL1RFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiL1REH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A936221801
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4705D61568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A8BC433EF;
        Wed, 28 Dec 2022 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246722;
        bh=cFuGLqk7wK2pepHQh2ikuLczkSKE1cvpSxrFp4f4fh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGBsyWogTS3RdAwvBZVV63wFejdIVWIPE4pSpQCtX8tjqRgJfptSGAIogRPZF9Ckw
         zgsfdPVDl7+ca9MxGbfLrk5FvWJAV4gjjrCe+OIoflW3/Ml1W2Fa2NtU8kQW9IZWKJ
         1qc70sECjVfKgXyyGFd1HNbCC1ZsUercm6xowMN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 1122/1146] iio: addac: ad74413r: fix integer promotion bug in ad74413_get_input_current_offset()
Date:   Wed, 28 Dec 2022 15:44:21 +0100
Message-Id: <20221228144400.623773293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 980389d06d08442fad0139874bff455c76125e47 upstream.

The constant AD74413R_ADC_RESULT_MAX is defined via GENMASK, so its
type is "unsigned long".

Hence in the expression voltage_offset * AD74413R_ADC_RESULT_MAX,
voltage_offset is first promoted to unsigned long, and since it may be
negative, that results in a garbage value. For example, when range is
AD74413R_ADC_RANGE_5V_BI_DIR, voltage_offset is -2500 and
voltage_range is 5000, so the RHS of this assignment is, depending on
sizeof(long), either 826225UL or 3689348814709142UL, which after
truncation to int then results in either 826225 or 1972216214 being
the output from in_currentX_offset.

Casting to int avoids that promotion and results in the correct -32767
output.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Fixes: fea251b6a5db (iio: addac: add AD74413R driver)
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20221118123209.1658420-1-linux@rasmusvillemoes.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/ad74413r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -691,7 +691,7 @@ static int ad74413_get_input_current_off
 	if (ret)
 		return ret;
 
-	*val = voltage_offset * AD74413R_ADC_RESULT_MAX / voltage_range;
+	*val = voltage_offset * (int)AD74413R_ADC_RESULT_MAX / voltage_range;
 
 	return IIO_VAL_INT;
 }


