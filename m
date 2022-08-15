Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2659359464A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350653AbiHOWTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347522AbiHOWP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:15:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53F4120A84;
        Mon, 15 Aug 2022 12:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9D88B80EA7;
        Mon, 15 Aug 2022 19:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3577CC433D6;
        Mon, 15 Aug 2022 19:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592378;
        bh=09RnNxg19SQJ4cNTRE294GN7J1KK248eGE8198Ys4xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCQ6pOgRr7QTGYAmZ8JNSsRI/5fAGBzAhPvC/eWhxWcZNtMcSzgBmTwOUfGkeYd+t
         ZvfsQuKauPFHaSfQBsGLG5wukNe87iNiTrDV+Eb6ezS9/tIgVgQLnmI49U/zjBXTD7
         WL8qc7Q4wB5G9exSELvhIN8S2g3Rj9NYIEuM7AcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0778/1095] iio: adc: max1027: unlock on error path in max1027_read_single_value()
Date:   Mon, 15 Aug 2022 20:02:57 +0200
Message-Id: <20220815180501.444960645@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



