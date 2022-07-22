Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E057DBD7
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiGVIL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 04:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGVIL2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 22 Jul 2022 04:11:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B969CE0B
        for <Stable@vger.kernel.org>; Fri, 22 Jul 2022 01:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56BCF6170B
        for <Stable@vger.kernel.org>; Fri, 22 Jul 2022 08:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551F5C341C6;
        Fri, 22 Jul 2022 08:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658477486;
        bh=GqyjTSiOdBXKdv6q1v9OJGSr6MYsAgIyC0heMCuf7Do=;
        h=Subject:To:From:Date:From;
        b=cSJJ3MeZ7MyR4SXht3ezNuuYM0hQtIiDV8c1CnBjuOdM4qgMDZuiwhUsB7E4q5yUB
         xIynrr2G9BrVI822Y6aohTw7gqHoDSs9NCoaiLBYY1Cv+6f2/2mpw8q2A+JePE7ErB
         pEth593GbEO04gstMdNXvxtHYxOxTH2dsjhKxxVA=
Subject: patch "iio: fix iio_format_avail_range() printing for none IIO_VAL_INT" added to char-misc-testing
To:     fawzi.khaber@tdk.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jean-baptiste.maneyrol@tdk.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jul 2022 10:03:33 +0200
Message-ID: <165847701312691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: fix iio_format_avail_range() printing for none IIO_VAL_INT

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 5e1f91850365de55ca74945866c002fda8f00331 Mon Sep 17 00:00:00 2001
From: Fawzi Khaber <fawzi.khaber@tdk.com>
Date: Mon, 18 Jul 2022 15:07:06 +0200
Subject: iio: fix iio_format_avail_range() printing for none IIO_VAL_INT

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
---
 drivers/iio/industrialio-core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 358b909298c0..0f4dbda3b9d3 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -812,7 +812,23 @@ static ssize_t iio_format_avail_list(char *buf, const int *vals,
 
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
-- 
2.37.1


