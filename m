Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B099D6CBDC7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjC1LcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjC1LcJ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C7CAB
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12907616E0
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229A7C433D2;
        Tue, 28 Mar 2023 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003121;
        bh=nt6AW+mV/aH/i6pkCqV0+cnkmhDZZE4BrFBZEHT0iaQ=;
        h=Subject:To:From:Date:From;
        b=CXxAJMAYKMPFHgiM7rS4rGzA8B8O0AckAC/4LYy7/0rZodtVcZiD3NqJmtu+IZ9HZ
         PcDsZsnqhnU1jXy+Td6zzVF6YDcfofTlgbQmkC3TpF+H2L8D0hl8/uhJzaokIZxiGT
         De1p4j/ep7LImyxBoKp5hYMTSoQ+ZBZx7zfQHhLA=
Subject: patch "iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, david@lechnology.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:32 +0200
Message-ID: <168000309218034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 363c7dc72f79edd55bf1c4380e0fbf7f1bbc2c86 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun, 12 Mar 2023 14:09:33 -0700
Subject: iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

The ads7950 uses a mutex as well as SPI transfers in its GPIO callbacks.
This means these callbacks can sleep and the `can_sleep` flag should be
set.

Having the flag set will make sure that warnings are generated when calling
any of the callbacks from a potentially non-sleeping context.

Fixes: c97dce792dc8 ("iio: adc: ti-ads7950: add GPIO support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: David Lechner <david@lechnology.com>
Link: https://lore.kernel.org/r/20230312210933.2275376-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads7950.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index 2cc9a9bd9db6..263fc3a1b87e 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -634,6 +634,7 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	st->chip.label = dev_name(&st->spi->dev);
 	st->chip.parent = &st->spi->dev;
 	st->chip.owner = THIS_MODULE;
+	st->chip.can_sleep = true;
 	st->chip.base = -1;
 	st->chip.ngpio = TI_ADS7950_NUM_GPIOS;
 	st->chip.get_direction = ti_ads7950_get_direction;
-- 
2.40.0


