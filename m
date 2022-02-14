Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A344B45B2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiBNJ2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242964AbiBNJ2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FD060AA5;
        Mon, 14 Feb 2022 01:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0351460F8B;
        Mon, 14 Feb 2022 09:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD90CC340E9;
        Mon, 14 Feb 2022 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830890;
        bh=js+fuAM4/WE8FT7Gl8fPuy4DPVo7Bz7KVm+bzuIfYAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQSEnNsqXrJwDsfwaEz0clrxR2qUZdu6emKPG8Cx66IQsszxIUwqGJpxaKcT5WQ3F
         4VfowNaVwERHo5NVvUHm4NQF0/SBYdTZK7uR1bySL8C85+MojGaOu4qw3j8vFOoADS
         4gteS3/oV9VWO/F4neRmqw9/tjIMSls2z0HtJBto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/34] usb: dwc2: gadget: dont try to disable ep0 in dwc2_hsotg_suspend
Date:   Mon, 14 Feb 2022 10:25:39 +0100
Message-Id: <20220214092446.379049043@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index e7ad3ae4ea6bd..65bcbbad6d545 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3979,7 +3979,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-- 
2.34.1



