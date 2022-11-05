Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E914161D968
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 11:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKEKdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 06:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKEKdT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 5 Nov 2022 06:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B281AD8A
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 03:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAC66B81CD0
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 10:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DEBC433C1;
        Sat,  5 Nov 2022 10:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667644396;
        bh=b7ZwMt9Cy6/qaCVALoeIGIAXt2RIeutSZXeP2tuNZAA=;
        h=Subject:To:From:Date:From;
        b=1G6M29oYxBfgMl0YXlIjAAs2/a7bGQGRiQxwoaXfz2LzyhdL4OT2nIn+sYtutoqqc
         Nk2cWdAFV/axi3cKfZ5Do90uFSiz1SsifMu1VM0N+eArbtLa88xKPsq0tQoJYhLQkF
         fll1Vr2WXjqUXVQSg5/Z7h9VlCXapdyiSpqYsmaw=
Subject: patch "iio: adc: mp2629: fix potential array out of bound access" added to char-misc-linus
To:     sravanhome@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Nov 2022 11:33:01 +0100
Message-ID: <16676443818924@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: mp2629: fix potential array out of bound access

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ca1547ab15f48dc81624183ae17a2fd1bad06dfc Mon Sep 17 00:00:00 2001
From: Saravanan Sekar <sravanhome@gmail.com>
Date: Sat, 29 Oct 2022 11:29:55 +0200
Subject: iio: adc: mp2629: fix potential array out of bound access

Add sentinel at end of maps to avoid potential array out of
bound access in iio core.

Fixes: 7abd9fb64682 ("iio: adc: mp2629: Add support for mp2629 ADC driver")
Signed-off-by: Saravanan Sekar <sravanhome@gmail.com>
Link: https://lore.kernel.org/r/20221029093000.45451-4-sravanhome@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/mp2629_adc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mp2629_adc.c b/drivers/iio/adc/mp2629_adc.c
index f7af9af1665d..88e947f300cf 100644
--- a/drivers/iio/adc/mp2629_adc.c
+++ b/drivers/iio/adc/mp2629_adc.c
@@ -57,7 +57,8 @@ static struct iio_map mp2629_adc_maps[] = {
 	MP2629_MAP(SYSTEM_VOLT, "system-volt"),
 	MP2629_MAP(INPUT_VOLT, "input-volt"),
 	MP2629_MAP(BATT_CURRENT, "batt-current"),
-	MP2629_MAP(INPUT_CURRENT, "input-current")
+	MP2629_MAP(INPUT_CURRENT, "input-current"),
+	{ }
 };
 
 static int mp2629_read_raw(struct iio_dev *indio_dev,
-- 
2.38.1


