Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1574A8F0C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiBCUmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355926AbiBCUkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:40:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C55C0619C7;
        Thu,  3 Feb 2022 12:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC4C460C5D;
        Thu,  3 Feb 2022 20:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C64BC340EB;
        Thu,  3 Feb 2022 20:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920608;
        bh=5iuORTELvsKpZaPEF5mrgRcATjPKHLLV9RGRvSPJiN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+yprcdpNKmypADhrnrMDf5lqMdB7/8Awf+828A10i21jX8Y6+F0o1GChCyzVezux
         TH6dzVI2HiYfgCp4KmLtoIiVv+9+rQccnyt2noYYcrmmo44pqrHTQumFuwwuCimoeR
         HGXocn76AfK4/HW2Yfu71v2uhAgAb4tEiDtzvqjr1nuDjJ1n/RtugoEbOEYlfHDYCN
         NDaafhDtH1b7OJI1nQiP7Eo+DFRqlYOEmAfdRLMU8GH5Bc+hTqxql8kDGRmGJ5wxtW
         Y7s/oP/tpGf6Xlr2e5Oa69ljlcXHT0cnm383Cww4QEbcfYjIcPid0MoHiEAZYlIVWP
         cXERPKe/nzAAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/9] usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend
Date:   Thu,  3 Feb 2022 15:36:32 -0500
Message-Id: <20220203203633.4685-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203633.4685-1-sashal@kernel.org>
References: <20220203203633.4685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit ac55d163855924aa5af9f1560977da8f346963c8 ]

Calling dwc2_hsotg_ep_disable on ep0 (in/out) will lead to the following
logs before returning -EINVAL:
dwc2 49000000.usb-otg: dwc2_hsotg_ep_disable: called for ep0
dwc2 49000000.usb-otg: dwc2_hsotg_ep_disable: called for ep0

To avoid these two logs while suspending, start disabling the endpoint
from the index 1, as done in dwc2_hsotg_udc_stop:

	/* all endpoints should be shutdown */
	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
		if (hsotg->eps_in[ep])
			dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
		if (hsotg->eps_out[ep])
			dwc2_hsotg_ep_disable_lock(&hsotg->eps_out[ep]->ep);
	}

Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211207130101.270314-1-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index f1edc5727000c..dddc5d02b5524 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4783,7 +4783,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-- 
2.34.1

