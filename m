Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF2810BFAF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfK0VpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:45:18 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:34670 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727963AbfK0VpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 16:45:18 -0500
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E493AC0382;
        Wed, 27 Nov 2019 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1574891117; bh=6Hfao375F+NO+iwnFV8Dj3+NEuvO6/Yjg572T9OTy0M=;
        h=Date:From:Subject:To:Cc:From;
        b=QuDHZYdXO70yU3Lv81gOlGCOS6Aqja7Wq1Ez99Idu8cdj8U1xz1HM61O3XoORUu9z
         WE0wKP6czUy4AxgF4cg+UW2cWGyP6H5hGwnYy9WuyLioWmpaqTnQdZjSDzGb/41KYM
         hfSb6Z2CNOtJLDFp2bzx7RgFLfNabEaA080cwQ5GM5VL4PuZOelokDVSDRKBeDrZnY
         VACaSrLI9nuUqE3DM2w4ym8i1jbBmLJEx5OaqBsBGzAaVuvpEmH4Ycc/Qc/NcmufJw
         sCD8SKLcJ6laYu51JLdU3q8q7kHU2DkjeAOUmqTJswUgltrmP2/02B2TgmS6FCxeNh
         cuesFZFYB198Q==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 8F042A007B;
        Wed, 27 Nov 2019 21:45:16 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 27 Nov 2019 13:45:15 -0800
Date:   Wed, 27 Nov 2019 13:45:15 -0800
Message-Id: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function driver may try to enable an unconfigured endpoint. This
check make sure that we do not attempt to access a NULL descriptor and
crash.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7f97856e6b20..00f8f079bbf2 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -619,6 +619,9 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 	u32			reg;
 	int			ret;
 
+	if (!desc)
+		return -EINVAL;
+
 	if (!(dep->flags & DWC3_EP_ENABLED)) {
 		ret = dwc3_gadget_start_config(dep);
 		if (ret)
-- 
2.11.0

