Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500914A8DAB
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbiBCUcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37254 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354468AbiBCUbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1325D61A66;
        Thu,  3 Feb 2022 20:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEF5C340F0;
        Thu,  3 Feb 2022 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920298;
        bh=WFqTIFbcouaApt5mdXLi6vKpn1Gu/pyOz2IiuG4k3xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhs8J4/CF26wXp6Knp1vPGgQQfVQUUlnCkS/S6Nf55PButSOnBwezRPH7lfXMWwt4
         eUpvQlmkg7cGBFDzJl59ZlNNTotqWwv0GwTODD0I6H0fBSYHscJzKwsLCaA5tybU03
         GZNBrXw7QF+ljQsYEGlYK1J3HSAyDxGMQTohOEEd4fNi0/VwCVjntcgPI0Xr4udQKC
         ifHfBf+7Ng/s+NiuyiHdVPiDEagy7iLjekTaFhH46hlSimIBFYCKQjI1HUyvPbgiZ4
         srx+kzxSF++rGtBNhNYNOe1y4ecjtxgI8/YZi/eor+CBXobShpM05U3dvNXqD2KrIV
         K4zoNwTOD6zQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, hminas@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 41/52] usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend
Date:   Thu,  3 Feb 2022 15:29:35 -0500
Message-Id: <20220203202947.2304-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 43cf49c4e5e59..da82e4140d545 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -5097,7 +5097,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-- 
2.34.1

