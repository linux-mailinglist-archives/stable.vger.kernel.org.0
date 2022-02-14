Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1164B462D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiBNJb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:31:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243294AbiBNJbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:31:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9560D87;
        Mon, 14 Feb 2022 01:30:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4744A60F87;
        Mon, 14 Feb 2022 09:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31135C340E9;
        Mon, 14 Feb 2022 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831006;
        bh=5iuORTELvsKpZaPEF5mrgRcATjPKHLLV9RGRvSPJiN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tb8wTV7aLY1MeA3aRe1m3XV2UMcU+e7Z/6z/NJ+FFKj4DDMfqNJBLFImO9dlro0yQ
         95PuMVv5GAQWndDUtB1rWAismYlH1DhHlX34iAvNx/3P2BShlPqsasxbHuETAjjsXf
         6xzSP7LeKkrKqTcFeupoc0qfoxfDlHlpbsdHpfXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/44] usb: dwc2: gadget: dont try to disable ep0 in dwc2_hsotg_suspend
Date:   Mon, 14 Feb 2022 10:25:37 +0100
Message-Id: <20220214092448.373945460@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
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



