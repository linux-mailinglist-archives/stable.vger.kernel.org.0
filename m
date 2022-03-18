Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3044DD982
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiCRMR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbiCRMR5 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 08:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3A6F210D
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 05:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BB2561870
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 12:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B2EC340E8;
        Fri, 18 Mar 2022 12:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647605798;
        bh=eWjmqUGGUJKSeJfIV5Xu7E83NFc4OdxDtHw9zaFl+/U=;
        h=Subject:To:From:Date:From;
        b=f8SukPK0nvLRrx844On+LeHAzk6+A8MJ++NUX7OrrJrCYiiGsej13SV+U19WWfoux
         hv2ujm06dK0rZAIXWud7x3lFbZ7tygk6JY+0Ewd6ETDABUrPjmsC7+tm6O9BwkM8R9
         3TLOTDxllVIwXA/qgSVGiirf78Hh93mDJHdvF6qs=
Subject: patch "iio: adc: xilinx-ams: Fixed missing PS channels" added to char-misc-next
To:     robert.hancock@calian.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, m.tretter@pengutronix.de,
        michal.simek@xilinx.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:46:40 +0100
Message-ID: <164760400023275@kroah.com>
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

    iio: adc: xilinx-ams: Fixed missing PS channels

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1f21a41578062d439cc485bce2d8b664f9a6170e Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 27 Jan 2022 11:34:48 -0600
Subject: iio: adc: xilinx-ams: Fixed missing PS channels

The code forgot to increment num_channels for the PS channel inputs,
resulting in them not being enabled as they should.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20220127173450.3684318-3-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/xilinx-ams.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index 6ffddf4038b8..6746bc966bfd 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1225,6 +1225,7 @@ static int ams_init_module(struct iio_dev *indio_dev,
 
 		/* add PS channels to iio device channels */
 		memcpy(channels, ams_ps_channels, sizeof(ams_ps_channels));
+		num_channels = ARRAY_SIZE(ams_ps_channels);
 	} else if (fwnode_property_match_string(fwnode, "compatible",
 						"xlnx,zynqmp-ams-pl") == 0) {
 		ams->pl_base = fwnode_iomap(fwnode, 0);
-- 
2.35.1


