Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4504DD94F
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiCRL6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiCRL6x (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 07:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E29D151D0E
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 04:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF24614CB
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 11:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FF5C340E8;
        Fri, 18 Mar 2022 11:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604654;
        bh=4WV9h79BRubZu2DXbMHdWT3OnypT9DCg1oryz+UmBvM=;
        h=Subject:To:From:Date:From;
        b=uiOVQR1YOsM9RAvLfh5XV+srxkCD8McH8RqXc20T+n7gfxKDi0Z9YJ6AKUE9gddVe
         B2B1utncsGwYOSz539RfqaVApc1XO6qvhfCcwxTwAbsu2ecLbwcLANsYzy+qt+6/2Q
         XRa4x8lpkO4gp9E/U9zJsy1hrFlOnnAsk7QNo1x8=
Subject: patch "iio: adc: xilinx-ams: Fix single channel switching sequence" added to char-misc-testing
To:     robert.hancock@calian.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, michal.simek@xilinx.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:43:50 +0100
Message-ID: <16476038302147@kroah.com>
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

    iio: adc: xilinx-ams: Fix single channel switching sequence

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 0bf126163c3e7e6d722622073046aed567a5551e Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 27 Jan 2022 11:34:50 -0600
Subject: iio: adc: xilinx-ams: Fix single channel switching sequence

Some of the AMS channels need to be read by switching into single-channel
mode from the normal polling sequence. There was a logic issue in this
switching code that could cause the first read of these channels to read
back as zero.

It appears that the sequencer should be set back to default mode before
changing the channel selection, and the channel should be set before
switching the sequencer back into single-channel mode.

Also, write 1 to the EOC bit in the status register to clear it before
waiting for it to become set, so that we actually wait for a new
conversion to complete, and don't proceed based on a previous conversion
completing.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20220127173450.3684318-5-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/xilinx-ams.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index 0c491667c464..a55396c1f8b2 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -531,14 +531,18 @@ static int ams_enable_single_channel(struct ams *ams, unsigned int offset)
 		return -EINVAL;
 	}
 
-	/* set single channel, sequencer off mode */
+	/* put sysmon in a soft reset to change the sequence */
 	ams_ps_update_reg(ams, AMS_REG_CONFIG1, AMS_CONF1_SEQ_MASK,
-			  AMS_CONF1_SEQ_SINGLE_CHANNEL);
+			  AMS_CONF1_SEQ_DEFAULT);
 
 	/* write the channel number */
 	ams_ps_update_reg(ams, AMS_REG_CONFIG0, AMS_CONF0_CHANNEL_NUM_MASK,
 			  channel_num);
 
+	/* set single channel, sequencer off mode */
+	ams_ps_update_reg(ams, AMS_REG_CONFIG1, AMS_CONF1_SEQ_MASK,
+			  AMS_CONF1_SEQ_SINGLE_CHANNEL);
+
 	return 0;
 }
 
@@ -552,6 +556,8 @@ static int ams_read_vcc_reg(struct ams *ams, unsigned int offset, u32 *data)
 	if (ret)
 		return ret;
 
+	/* clear end-of-conversion flag, wait for next conversion to complete */
+	writel(expect, ams->base + AMS_ISR_1);
 	ret = readl_poll_timeout(ams->base + AMS_ISR_1, reg, (reg & expect),
 				 AMS_INIT_POLL_TIME_US, AMS_INIT_TIMEOUT_US);
 	if (ret)
-- 
2.35.1


