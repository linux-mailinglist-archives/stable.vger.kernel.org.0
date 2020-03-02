Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7594717664E
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 22:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCBVot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 16:44:49 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44710 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgCBVot (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 16:44:49 -0500
Received: by mail-pg1-f195.google.com with SMTP id a14so445274pgb.11
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 13:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4Y3ObTGarg5FSEMw5sy9VH68aTZS5szI2sN7gCsNGVk=;
        b=eQSofJhH/+iTx+5JQ5yxGwjEuHa1BvH0/uRrXBVnpM6oVu2o/WCVZlvyy4KVqZCfIU
         K/BstL1P9irmhKujSgxC21S67oMoQAAwtV2fX9Wksw9rY9XYNcdLjustJ4gHopJczxrx
         OIQyRJzue5x/ia8NDW/JQgmFIXU7p2Yb9Tmg7Z1vUeSLYXSGVjZ50yIFFS49AogQ5dQs
         +smFGVxG7GzvElalaj66J0TaavSIZdwBWJP68Fb7GG32dCvyCcOApd1UhA/2+hMNp/zK
         feyHJFt2SVoCJ8lfKAHgKaw1PxrZdjFChc25V3Y51SFIom5IqvQyG9u23UePVCc0I9Er
         4pkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4Y3ObTGarg5FSEMw5sy9VH68aTZS5szI2sN7gCsNGVk=;
        b=PdGQTPMfSgyqMTBU8jbXmAQTmUgRFk7cMR/XsZxLxO/dduQwWf6WcOyT8ZyzsziwXo
         CNIGj5kAy2bidypmiKlpnTIKtpxrFyKr88Q7pEl19d6qjMTXiKQfoi55MT+g77gstuA2
         xsQ5q1D849BRnfnWhClqQPb4R5KtMmqZsgRudK7vZv1Il/zGMGjRTW8RHHSbOgP91T6O
         uHNveSP9W/lvt/SyLKHIoQ4ZbZQy/U+QdZeyaQM2gqebGmPBINu65+MZrcjywEJSHThJ
         xTwP3yRghjyVOFYvVE83u5xJRI7Y5xXoP/DWOdDcPyLe02d9QIHVvdD4jBMzC5X0eedj
         Gicw==
X-Gm-Message-State: ANhLgQ25wKKmDGhTQl3vElqiexcp+Zp1QP09lmcNTgMWQKws6lLtzCLY
        Zxa1syGaaJNL2MBmYpqP1VIs5Q==
X-Google-Smtp-Source: ADFU+vvwaFfaYzRy+WqqPZG1NBwX75qifdGXa03PdoCWDVY1D1w3m7zNwD2USUnR1U6pC0T3j49MPA==
X-Received: by 2002:a63:f354:: with SMTP id t20mr870398pgj.126.1583185488289;
        Mon, 02 Mar 2020 13:44:48 -0800 (PST)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id v25sm21573567pfe.147.2020.03.02.13.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 13:44:47 -0800 (PST)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     Pratham Pratap <prathampratap@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>, Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [RESEND][PATCH v2] usb: dwc3: gadget: Update chain bit correctly when using sg list
Date:   Mon,  2 Mar 2020 21:44:43 +0000
Message-Id: <20200302214443.55783-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pratham Pratap <prathampratap@codeaurora.org>

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
---
v2:
* Fix typeos and unnecssary parens as suggested by Jack
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
2.17.1

