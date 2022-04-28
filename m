Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC5E513711
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348498AbiD1OlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiD1OlT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 28 Apr 2022 10:41:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936D5515BF
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 07:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33A98B8185B
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 14:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72198C385A0;
        Thu, 28 Apr 2022 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651156681;
        bh=AtES0cBGeGMX8baYb0aUM9itUdyZtWhBoSnE4+rQeBc=;
        h=Subject:To:From:Date:From;
        b=UO8jboU3dAXxJiX+5o8WMz/I94v+/hM1PMTnj7XpTEonoww1tpEayXm7EixdGj4ah
         4SjGOL48nQVi5higXANxr01FUnjHHN/evH98jQO5/+j/RsHOqVLRDSxVt5J/LrfOuo
         6/vpbhuPFGmKfGRLZMwR5xpDIb86bhpZd/DpE2Ds=
Subject: patch "iio: dac: ad5592r: Fix the missing return value." added to char-misc-linus
To:     sunsetdzz@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Apr 2022 16:37:51 +0200
Message-ID: <165115667122573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5592r: Fix the missing return value.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b55b38f7cc12da3b9ef36e7a3b7f8f96737df4d5 Mon Sep 17 00:00:00 2001
From: Zizhuang Deng <sunsetdzz@gmail.com>
Date: Thu, 10 Mar 2022 20:54:50 +0800
Subject: iio: dac: ad5592r: Fix the missing return value.

The third call to `fwnode_property_read_u32` did not record
the return value, resulting in `channel_offstate` possibly
being assigned the wrong value.

Fixes: 56ca9db862bf ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Signed-off-by: Zizhuang Deng <sunsetdzz@gmail.com>
Link: https://lore.kernel.org/r/20220310125450.4164164-1-sunsetdzz@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5592r-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5592r-base.c b/drivers/iio/dac/ad5592r-base.c
index a424b7220b61..4434c1b2a322 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -522,7 +522,7 @@ static int ad5592r_alloc_channels(struct iio_dev *iio_dev)
 		if (!ret)
 			st->channel_modes[reg] = tmp;
 
-		fwnode_property_read_u32(child, "adi,off-state", &tmp);
+		ret = fwnode_property_read_u32(child, "adi,off-state", &tmp);
 		if (!ret)
 			st->channel_offstate[reg] = tmp;
 	}
-- 
2.36.0


