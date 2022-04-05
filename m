Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FF54F24E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiDEHmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiDEHlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDCE4B871;
        Tue,  5 Apr 2022 00:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0BC9B81B16;
        Tue,  5 Apr 2022 07:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D91CC340EE;
        Tue,  5 Apr 2022 07:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144392;
        bh=iy6lksg609i4AYODstSzuabS3QmBmkPLkoK1AMgigFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0q9fV78zfyNSQxwHJalw7rqqbuEMMINjhal8AFhzwSeNvP/7j+yaBKw5plRYcgo9
         iUEWVhquspmJKXTQ8a+AsXdOfY15rwpF+vrCQzI2jqXm78Lqh7SzjpDm/cOqAwVbtd
         YFlcVPqBOqJx9pKpxemuCDbTpd5X1AgWAUf1GVt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Michal Simek <michal.simek@xilinx.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0029/1126] iio: adc: xilinx-ams: Fix single channel switching sequence
Date:   Tue,  5 Apr 2022 09:12:56 +0200
Message-Id: <20220405070408.407392004@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Robert Hancock <robert.hancock@calian.com>

commit 0bf126163c3e7e6d722622073046aed567a5551e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -530,14 +530,18 @@ static int ams_enable_single_channel(str
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
 
@@ -551,6 +555,8 @@ static int ams_read_vcc_reg(struct ams *
 	if (ret)
 		return ret;
 
+	/* clear end-of-conversion flag, wait for next conversion to complete */
+	writel(expect, ams->base + AMS_ISR_1);
 	ret = readl_poll_timeout(ams->base + AMS_ISR_1, reg, (reg & expect),
 				 AMS_INIT_POLL_TIME_US, AMS_INIT_TIMEOUT_US);
 	if (ret)


