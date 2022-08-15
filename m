Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CD159353C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiHOSVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240654AbiHOSUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:20:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429D02C669;
        Mon, 15 Aug 2022 11:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D950CB8106C;
        Mon, 15 Aug 2022 18:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FC0C433D6;
        Mon, 15 Aug 2022 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587406;
        bh=Atfdsdi8h9Ub1cnJDu2gkrI2QGWBUcfrKIUIaTCa4Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCg4oG3ST7hmD+wOEyVZ+wfnPBt+4bqWf0Z7Cb0PO3M5tbQN7zqqbk8lC94Jpvt7W
         gmKibv0Dz3MhtJSmxZAJHYu2zVhcT2swwB9yDX/qEldXeMz6bInfQHxDKB3JgjGzFp
         N82rhLYAL+/WOa1yXILXPnQ4LbJVNyenyXksJiR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fawzi Khaber <fawzi.khaber@tdk.com>,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 076/779] iio: fix iio_format_avail_range() printing for none IIO_VAL_INT
Date:   Mon, 15 Aug 2022 19:55:20 +0200
Message-Id: <20220815180340.548731211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -818,7 +818,23 @@ static ssize_t iio_format_avail_list(cha
 
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


