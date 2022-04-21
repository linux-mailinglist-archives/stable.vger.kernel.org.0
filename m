Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375BD50A6E2
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 19:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388106AbiDURUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 13:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377011AbiDURUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 13:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5117C49F83
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 10:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E202661DC8
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 17:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E58C385A5;
        Thu, 21 Apr 2022 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650561437;
        bh=VRraGfNSZx3EgVsIK/2VbTxJf/FftdvgzN2jaCABJcI=;
        h=Subject:To:From:Date:From;
        b=Aj8QkgJG2FQW9UHmARUNRWaHAN8FlAhRFAeh1D9aghXjwTizq/N3Kp21bn6biFO5w
         Q/UpN9GIUYQb/uWZnjzvbvaNTzvW6bHKvbHDEUshxsa9f8MSCewCTxqDflgnFiBA5F
         idfcqWZQz2KMYD63xm7yfTmn8JURwlZWpuMUZoBw=
Subject: patch "usb: dwc3: core: Fix tx/rx threshold settings" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Apr 2022 19:17:06 +0200
Message-ID: <165056142614821@kroah.com>
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

    usb: dwc3: core: Fix tx/rx threshold settings

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f28ad9069363dec7deb88032b70612755eed9ee6 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 11 Apr 2022 18:33:47 -0700
Subject: usb: dwc3: core: Fix tx/rx threshold settings

The current driver logic checks against 0 to determine whether the
periodic tx/rx threshold settings are set, but we may get bogus values
from uninitialized variables if no device property is set. Properly
default these variables to 0.

Fixes: 938a5ad1d305 ("usb: dwc3: Check for ESS TX/RX threshold config")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/cccfce990b11b730b0dae42f9d217dc6fb988c90.1649727139.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 5bfd3e88af35..1ca9dae57855 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1377,10 +1377,10 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 	u8			lpm_nyet_threshold;
 	u8			tx_de_emphasis;
 	u8			hird_threshold;
-	u8			rx_thr_num_pkt_prd;
-	u8			rx_max_burst_prd;
-	u8			tx_thr_num_pkt_prd;
-	u8			tx_max_burst_prd;
+	u8			rx_thr_num_pkt_prd = 0;
+	u8			rx_max_burst_prd = 0;
+	u8			tx_thr_num_pkt_prd = 0;
+	u8			tx_max_burst_prd = 0;
 	u8			tx_fifo_resize_max_num;
 	const char		*usb_psy_name;
 	int			ret;
-- 
2.36.0


