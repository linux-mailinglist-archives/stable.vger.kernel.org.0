Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10875942EE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348155AbiHOWUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345855AbiHOWO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:14:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E79567473;
        Mon, 15 Aug 2022 12:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5668B81136;
        Mon, 15 Aug 2022 19:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35D3C433D6;
        Mon, 15 Aug 2022 19:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592375;
        bh=Eyld/4JG6PhdZddQPy7uQIKN0fHrDm8Y8aZZ1sd1+VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILWLujrKP3uUZtv73cF9aNihNiI7ERvxG6+i8yO73O8k5OtBjweB+Fy26Pxl72yml
         MJx0Jh7JJEPzWH5gczQI6C8ge2ofqUxMO4EewWqMxcMp/kwvyPrgWN2VE8BmHcgvx7
         VxByfwaZQUgMGkGxPuWB0RNwh00IqyjCeiMbCM/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fawzi Khaber <fawzi.khaber@tdk.com>,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.19 0101/1157] iio: fix iio_format_avail_range() printing for none IIO_VAL_INT
Date:   Mon, 15 Aug 2022 19:50:57 +0200
Message-Id: <20220815180443.673794513@linuxfoundation.org>
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

From: Fawzi Khaber <fawzi.khaber@tdk.com>

commit 5e1f91850365de55ca74945866c002fda8f00331 upstream.

iio_format_avail_range() should print range as follow [min, step, max], so
the function was previously calling iio_format_list() with length = 3,
length variable refers to the array size of values not the number of
elements. In case of non IIO_VAL_INT values each element has integer part
and decimal part. With length = 3 this would cause premature end of loop
and result in printing only one element.

Signed-off-by: Fawzi Khaber <fawzi.khaber@tdk.com>
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Fixes: eda20ba1e25e ("iio: core: Consolidate iio_format_avail_{list,range}()")
Link: https://lore.kernel.org/r/20220718130706.32571-1-jmaneyrol@invensense.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -835,7 +835,23 @@ static ssize_t iio_format_avail_list(cha
 
 static ssize_t iio_format_avail_range(char *buf, const int *vals, int type)
 {
-	return iio_format_list(buf, vals, type, 3, "[", "]");
+	int length;
+
+	/*
+	 * length refers to the array size , not the number of elements.
+	 * The purpose is to print the range [min , step ,max] so length should
+	 * be 3 in case of int, and 6 for other types.
+	 */
+	switch (type) {
+	case IIO_VAL_INT:
+		length = 3;
+		break;
+	default:
+		length = 6;
+		break;
+	}
+
+	return iio_format_list(buf, vals, type, length, "[", "]");
 }
 
 static ssize_t iio_read_channel_info_avail(struct device *dev,


