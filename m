Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7714DD94E
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiCRL6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiCRL6t (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 07:58:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C62C5425
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 04:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD186617E4
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 11:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5815C340E8;
        Fri, 18 Mar 2022 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604650;
        bh=GTZx9CWPntMHgDtJAzPZtNV868DVBIXXD0MsGQN3x9o=;
        h=Subject:To:From:Date:From;
        b=kJE4tWBIL1iErA0+JTlvAkF+GrYXEO1uSgBOrVUSp8aKfSovETmUi8yh/Z9bdwfIS
         154GB9I6D28aDzh4ewSJazO6k0jQ1RnfheNDpVTpyPjygQr5+T5RtovkGOzViOKMm8
         igQAsGKSljXPIt7RzKI354cBZ0ite1N91U3afk+Y=
Subject: patch "iio: adc: xilinx-ams: Fixed wrong sequencer register settings" added to char-misc-testing
To:     robert.hancock@calian.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, m.tretter@pengutronix.de,
        michal.simek@xilinx.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:43:50 +0100
Message-ID: <16476038306533@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: xilinx-ams: Fixed wrong sequencer register settings

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From d5d786fb531697be74c567b3844c6897ddf1ffdd Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 27 Jan 2022 11:34:49 -0600
Subject: iio: adc: xilinx-ams: Fixed wrong sequencer register settings

Register settings used for the sequencer configuration register
were incorrect, causing some inputs to not be read properly.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20220127173450.3684318-4-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/xilinx-ams.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index 6746bc966bfd..0c491667c464 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -92,8 +92,8 @@
 
 #define AMS_CONF1_SEQ_MASK		GENMASK(15, 12)
 #define AMS_CONF1_SEQ_DEFAULT		FIELD_PREP(AMS_CONF1_SEQ_MASK, 0)
-#define AMS_CONF1_SEQ_CONTINUOUS	FIELD_PREP(AMS_CONF1_SEQ_MASK, 1)
-#define AMS_CONF1_SEQ_SINGLE_CHANNEL	FIELD_PREP(AMS_CONF1_SEQ_MASK, 2)
+#define AMS_CONF1_SEQ_CONTINUOUS	FIELD_PREP(AMS_CONF1_SEQ_MASK, 2)
+#define AMS_CONF1_SEQ_SINGLE_CHANNEL	FIELD_PREP(AMS_CONF1_SEQ_MASK, 3)
 
 #define AMS_REG_SEQ0_MASK		GENMASK(15, 0)
 #define AMS_REG_SEQ2_MASK		GENMASK(21, 16)
-- 
2.35.1


