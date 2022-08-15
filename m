Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4C7594D4C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346264AbiHPAcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352794AbiHPAbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5864B1859BA;
        Mon, 15 Aug 2022 13:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B90D9611D2;
        Mon, 15 Aug 2022 20:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1BBC433D6;
        Mon, 15 Aug 2022 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595766;
        bh=09RnNxg19SQJ4cNTRE294GN7J1KK248eGE8198Ys4xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeYd+pxgN3vcsTpqLbTFYF7420chX1DstmTocfo4B+KvUxFx+30S20gCBTpF4+mEs
         XkEdxrTNu++BBt9a3UcKLBGn4gKBYIBt+KRmfVnWbQz5zRRKsT4+JyG972SQPK2zyY
         2SoXOXo0aa6Ea8xL9mshNWsAEt+jVhsKhqyBZmEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0835/1157] iio: adc: max1027: unlock on error path in max1027_read_single_value()
Date:   Mon, 15 Aug 2022 20:03:11 +0200
Message-Id: <20220815180512.893249817@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 06ee60eb507f00fb3643876ec05318c63332dc88 ]

If max1027_wait_eoc() fails then call iio_device_release_direct_mode()
before returning.

Fixes: a0e831653ef9 ("iio: adc: max1027: Introduce an end of conversion helper")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YsbztVuAXnau2cIZ@kili
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1027.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
index b725d012625c..136fcf753837 100644
--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -349,8 +349,7 @@ static int max1027_read_single_value(struct iio_dev *indio_dev,
 	if (ret < 0) {
 		dev_err(&indio_dev->dev,
 			"Failed to configure conversion register\n");
-		iio_device_release_direct_mode(indio_dev);
-		return ret;
+		goto release;
 	}
 
 	/*
@@ -360,11 +359,12 @@ static int max1027_read_single_value(struct iio_dev *indio_dev,
 	 */
 	ret = max1027_wait_eoc(indio_dev);
 	if (ret)
-		return ret;
+		goto release;
 
 	/* Read result */
 	ret = spi_read(st->spi, st->buffer, (chan->type == IIO_TEMP) ? 4 : 2);
 
+release:
 	iio_device_release_direct_mode(indio_dev);
 
 	if (ret < 0)
-- 
2.35.1



