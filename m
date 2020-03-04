Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1733178DFE
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 11:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCDKF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 05:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgCDKF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 05:05:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA392072D;
        Wed,  4 Mar 2020 10:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583316357;
        bh=V69KKgolq5BGQsGk7vu9k6UqoiIP3xR1+GaC7xSLRVE=;
        h=Subject:To:From:Date:From;
        b=Ptx5w2Cxj2GskKqWWSmKAN20KQElQGluqDg5tUrtCIqeR2tIRi6riOVzAmF5j3okc
         OEiKe/x6CWYMVi2t73uekvT4GPL2D/jK4eJ8CwyVIr4uNPKXCEQvRe/gBdynMDwz7j
         mKV/SE6Fl4tlfZWAmczt+4q13S1MQ+IcM8sO2dBA=
Subject: patch "usb: dwc3: gadget: Update chain bit correctly when using sg list" added to usb-linus
To:     prathampratap@codeaurora.org, andrzej.p@collabora.com,
        anurag.kumar.vulisha@xilinx.com, balbi@kernel.org,
        fei.yang@intel.com, gregkh@linuxfoundation.org,
        jackp@codeaurora.org, john.stultz@linaro.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        tejas.joglekar@synopsys.com, thinhn@synopsys.com, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 11:05:42 +0100
Message-ID: <158331634215928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Update chain bit correctly when using sg list

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dad2aff3e827b112f27fa5e6f2bf87a110067c3f Mon Sep 17 00:00:00 2001
From: Pratham Pratap <prathampratap@codeaurora.org>
Date: Mon, 2 Mar 2020 21:44:43 +0000
Subject: usb: dwc3: gadget: Update chain bit correctly when using sg list

If scatter-gather operation is allowed, a large USB request is split
into multiple TRBs. For preparing TRBs for sg list, driver iterates
over the list and creates TRB for each sg and mark the chain bit to
false for the last sg. The current IOMMU driver is clubbing the list
of sgs which shares a page boundary into one and giving it to USB driver.
With this the number of sgs mapped it not equal to the the number of sgs
passed. Because of this USB driver is not marking the chain bit to false
since it couldn't iterate to the last sg. This patch addresses this issue
by marking the chain bit to false if it is the last mapped sg.

At a practical level, this patch resolves USB transfer stalls
seen with adb on dwc3 based db845c, pixel3 and other qcom
hardware after functionfs gadget added scatter-gather support
around v4.20.

Credit also to Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
who implemented a very similar fix to this issue.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Yang Fei <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Jack Pham <jackp@codeaurora.org>
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>
Cc: stable <stable@vger.kernel.org> #4.20+
Signed-off-by: Pratham Pratap <prathampratap@codeaurora.org>
[jstultz: Slight tweak to remove sg_is_last() usage, reworked
          commit message, minor comment tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: https://lore.kernel.org/r/20200302214443.55783-1-john.stultz@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1b7d2f9cb673..1e00bf2d65a2 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1071,7 +1071,14 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 		unsigned int rem = length % maxp;
 		unsigned chain = true;
 
-		if (sg_is_last(s))
+		/*
+		 * IOMMU driver is coalescing the list of sgs which shares a
+		 * page boundary into one and giving it to USB driver. With
+		 * this the number of sgs mapped is not equal to the number of
+		 * sgs passed. So mark the chain bit to false if it isthe last
+		 * mapped sg.
+		 */
+		if (i == remaining - 1)
 			chain = false;
 
 		if (rem && usb_endpoint_dir_out(dep->endpoint.desc) && !chain) {
-- 
2.25.1


