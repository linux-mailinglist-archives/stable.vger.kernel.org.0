Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB259E3CB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbiHWMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbiHWMau (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 23 Aug 2022 08:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9043101C50
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 02:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37927B81C9F
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 09:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93888C43470;
        Tue, 23 Aug 2022 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247861;
        bh=KNbnlH5IK71EzBJXjbCV32Fa99yOrg38UkNEj8uVhfA=;
        h=Subject:To:From:Date:From;
        b=sibZ0fgFJc1+lx2uM2Orecc9TH2LFc+Vt26FewFOQsVDFbMLELRJ/nTTKSQxkbo/c
         8nvzd0HNXZ70ifa8Qesoo343mDlL7qjN19L4EcfSYyWbvs/j1UdhHgE5yvDVER0l6g
         hF8r7T8RWfAAdXbi5Z3AFbjpCgzyQUm50rBtZJGs=
Subject: patch "iio: adc: mcp3911: correct "microchip,device-addr" property" added to char-misc-linus
To:     marcus.folkesson@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 10:42:58 +0200
Message-ID: <16612441780254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    iio: adc: mcp3911: correct "microchip,device-addr" property

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cfbd76d5c9c449739bb74288d982bccf9ff822f4 Mon Sep 17 00:00:00 2001
From: Marcus Folkesson <marcus.folkesson@gmail.com>
Date: Fri, 22 Jul 2022 15:07:19 +0200
Subject: iio: adc: mcp3911: correct "microchip,device-addr" property

Go for the right property name that is documented in the bindings.

Fixes: 3a89b289df5d ("iio: adc: add support for mcp3911")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220722130726.7627-3-marcus.folkesson@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/mcp3911.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index f581cefb6719..f8875076ae80 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -210,7 +210,14 @@ static int mcp3911_config(struct mcp3911 *adc)
 	u32 configreg;
 	int ret;
 
-	device_property_read_u32(dev, "device-addr", &adc->dev_addr);
+	ret = device_property_read_u32(dev, "microchip,device-addr", &adc->dev_addr);
+
+	/*
+	 * Fallback to "device-addr" due to historical mismatch between
+	 * dt-bindings and implementation
+	 */
+	if (ret)
+		device_property_read_u32(dev, "device-addr", &adc->dev_addr);
 	if (adc->dev_addr > 3) {
 		dev_err(&adc->spi->dev,
 			"invalid device address (%i). Must be in range 0-3.\n",
-- 
2.37.2


