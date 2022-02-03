Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BC4A8F2D
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354201AbiBCUmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355762AbiBCUjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:39:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A23C061763;
        Thu,  3 Feb 2022 12:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71C6660AE2;
        Thu,  3 Feb 2022 20:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACF4C340F0;
        Thu,  3 Feb 2022 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920569;
        bh=kKxYwxXYIqJL/cwj+OvZGUQdnsYR479T9nmwdoZseuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEnw+WiT2L3qxhI+PwRaV+A9mTQ8BcNWAIqMajSGQU4ZL6qlt+qDOlpdjBdx2B9af
         ou/AuW+r7Jb1AyJjaBBQZ8zH8hcQ+PVu32NH8o92FQ/RUeLpiRe+zWOKZ+Amnt8lZU
         FnvmtoI++9C9IWtvEiYnyc/4680TgQ2BhmYo95CBk5LFwAaRrtxDpoVhfCoGpcyuwu
         TdyITO10V6FGlI54Iba4tnuBKuCho3AhX9UlJgagPrJ5l2TCr2PEMi268VClxXSF1X
         c14ngr01MDXw66yxphSKxeBmMOZZJdEDaj2fxGK4rDApWOIhN78grF4rs85ebbeh+L
         z7mZf8i6eCYBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/15] usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend
Date:   Thu,  3 Feb 2022 15:35:44 -0500
Message-Id: <20220203203545.3879-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
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
index 249e8e6aa9282..379bbf27c7ce8 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4979,7 +4979,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-- 
2.34.1

