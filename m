Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AAB4B4BE7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344574AbiBNKCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344037AbiBNJ7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E635AC52;
        Mon, 14 Feb 2022 01:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A52661252;
        Mon, 14 Feb 2022 09:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652E0C340F2;
        Mon, 14 Feb 2022 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832023;
        bh=7Wh51CxNRkFsP+UxkO1n+8BoQxcYRbLgccZ/aypOW70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWbqZFlpjp/gBtDuiKq4BR4qMlN0s6uRb1LoFp/4UdJ/Ue7owWH8PN9oBb1vclAhK
         AFGKIH+EFyz/fyVKx0j00TIxSuk/ySnILpqgmBrK8nSggPRU6AgmYijo+Wk2kqLHC3
         bZ5O5Fs7eMYbKP1QX7wFjWkJAJNHKgCEoDavncpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/172] usb: dwc2: gadget: dont try to disable ep0 in dwc2_hsotg_suspend
Date:   Mon, 14 Feb 2022 10:25:13 +0100
Message-Id: <20220214092508.292332419@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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



