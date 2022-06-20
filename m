Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9375511D7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiFTHwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbiFTHwB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125AD10575
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F727611FB
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC3EC3411B;
        Mon, 20 Jun 2022 07:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711520;
        bh=CrKVREt3cqbR/0HAlbUXKLhehBy5p95CdJugfzJwZ/k=;
        h=Subject:To:From:Date:From;
        b=DPwe/mfSRd0RyWlW0XAkuuUAiQ1wIDfiWuefaT/7eayLgC9ftnMfCkJ1TUAaZ32RX
         mM7uR2k5gw4CqqMJNDKGKSKFU/I7y+Td+LAsjMlBzy903SOe4pZynsumgxzOGT+qjM
         tn/sonoBCsqHvVoU6m+UujTtDAa2f0v6R/nGxOIU=
Subject: patch "iio:proximity:sx9324: Check ret value of" added to char-misc-linus
To:     shraash@google.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gwendal@chromium.org, lkp@intel.com,
        swboyd@chromium.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:52 +0200
Message-ID: <165571145221228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:proximity:sx9324: Check ret value of

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 70171ed6dc53d2f580166d47f5b66cf51a6d0092 Mon Sep 17 00:00:00 2001
From: Aashish Sharma <shraash@google.com>
Date: Mon, 13 Jun 2022 16:22:24 -0700
Subject: iio:proximity:sx9324: Check ret value of
 device_property_read_u32_array()

0-day reports:

drivers/iio/proximity/sx9324.c:868:3: warning: Value stored
to 'ret' is never read [clang-analyzer-deadcode.DeadStores]

Put an if condition to break out of switch if ret is non-zero.

Signed-off-by: Aashish Sharma <shraash@google.com>
Fixes: a8ee3b32f5da ("iio:proximity:sx9324: Add dt_binding support")
Reported-by: kernel test robot <lkp@intel.com>
[swboyd@chromium.org: Reword commit subject, add fixes tag]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20220613232224.2466278-1-swboyd@chromium.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/proximity/sx9324.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
index 70c37f664f6d..63fbcaa4cac8 100644
--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -885,6 +885,9 @@ sx9324_get_default_reg(struct device *dev, int idx,
 			break;
 		ret = device_property_read_u32_array(dev, prop, pin_defs,
 						     ARRAY_SIZE(pin_defs));
+		if (ret)
+			break;
+
 		for (pin = 0; pin < SX9324_NUM_PINS; pin++)
 			raw |= (pin_defs[pin] << (2 * pin)) &
 			       SX9324_REG_AFE_PH0_PIN_MASK(pin);
-- 
2.36.1


