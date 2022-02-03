Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A134A8E4C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiBCUgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:36:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355003AbiBCUeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:34:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3A5B835B5;
        Thu,  3 Feb 2022 20:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC5CC340EF;
        Thu,  3 Feb 2022 20:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920448;
        bh=7Wh51CxNRkFsP+UxkO1n+8BoQxcYRbLgccZ/aypOW70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eau2CuT4LpWAdFDkPtz2aVBmKQ5caiVyPF5fFvMPBAR5jRfzbeKboi5UD9wjknjz5
         x31yAsQQU+WhV+Kwdoe3eH+6il+no7NOcvy/Jmq2dswEPTFSgccs+y3Pix9KvRDMe7
         V56xFo4j0yFFcMcU/+9gV6v5m7CzCPnSTQzGU2ip3G0yr0XWoRRqGza3fvUWQhSPsG
         ytuI2PdOTV5p30GRaqBDE7ooWiMGpV5qS59CH1qp8B1CnxpkNvpnf4+lhhRFC2ApI1
         D4QyRQxdY/BlVLw9UMn9wFwMhrfZz6EqJbjB30I8StFgfmWzzQ7m8YecF3Ud4NN0S/
         2qBv3uR7Q+org==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 36/41] usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend
Date:   Thu,  3 Feb 2022 15:32:40 -0500
Message-Id: <20220203203245.3007-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
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
index ea0d2d6139a68..0909b088a284b 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -5096,7 +5096,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-- 
2.34.1

