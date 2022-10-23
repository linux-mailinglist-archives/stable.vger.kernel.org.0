Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5F609498
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 18:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJWQGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 12:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiJWQGv (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 23 Oct 2022 12:06:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35CE5C36B
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 09:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F6C6B80DB1
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 16:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2966C43470;
        Sun, 23 Oct 2022 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666541208;
        bh=M149zC9H6uGWMkMaqqZmN0gH8ZVj8sDrwB8Zw85R1EQ=;
        h=Subject:To:From:Date:From;
        b=HIYGVCIR47l+GO5Cer/GJf3pUl4AEqvv8KsNshVFpXCx1T0UHLqhKmKEFCPP+V3BZ
         MpO7uXpyzuOn953P6iipokXSsDmmEDahB2V3KSQlrHN6/gjcZ7iC/CmUAnoqazt4VS
         kvGn7Cm0N/V9USLk30JKWtZvZhKFiUbQw86e/WUE=
Subject: patch "tools: iio: iio_utils: fix digit calculation" added to char-misc-linus
To:     mazziesaccount@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Oct 2022 18:06:25 +0200
Message-ID: <1666541185124229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tools: iio: iio_utils: fix digit calculation

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 72b2aa38191bcba28389b0e20bf6b4f15017ff2b Mon Sep 17 00:00:00 2001
From: Matti Vaittinen <mazziesaccount@gmail.com>
Date: Thu, 13 Oct 2022 15:04:04 +0300
Subject: tools: iio: iio_utils: fix digit calculation

The iio_utils uses a digit calculation in order to know length of the
file name containing a buffer number. The digit calculation does not
work for number 0.

This leads to allocation of one character too small buffer for the
file-name when file name contains value '0'. (Eg. buffer0).

Fix digit calculation by returning one digit to be present for number
'0'.

Fixes: 096f9b862e60 ("tools:iio:iio_utils: implement digit calculation")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/Y0f+tKCz+ZAIoroQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 tools/iio/iio_utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index aadee6d34c74..8d35893b2fa8 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -547,6 +547,10 @@ static int calc_digits(int num)
 {
 	int count = 0;
 
+	/* It takes a digit to represent zero */
+	if (!num)
+		return 1;
+
 	while (num != 0) {
 		num /= 10;
 		count++;
-- 
2.38.1


