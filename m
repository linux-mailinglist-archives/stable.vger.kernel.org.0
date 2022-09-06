Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143C95AEC26
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239240AbiIFN5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239219AbiIFNwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD38D80020;
        Tue,  6 Sep 2022 06:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F246153B;
        Tue,  6 Sep 2022 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA17C433D7;
        Tue,  6 Sep 2022 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471616;
        bh=ZRAoLUtu8uRv0tJrbLp+O+tHa9erJ7AsNm8KsKz0XDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNSPmlkgxZDawcvtPFzFxAddGgeVtXB90k/XYcSaTPH1P8hRIX2H0m6quJY4qPrO+
         ygDgGxhPVjlTy3MSU8gLcj0RFRPYQSkGKXFG0sZIeYl0XJBOCFfRf7H1iU9yqF4vNN
         hqB8rmArTnxZe3j7h/D2orUgSvrR1yCgCH2UtRtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.15 087/107] usb: xhci-mtk: fix bandwidth release issue
Date:   Tue,  6 Sep 2022 15:31:08 +0200
Message-Id: <20220906132825.490789159@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 6020f480004a80cdad4ae5ee180a231c4f65595b upstream.

This happens when @udev->reset_resume is set to true, when usb resume,
the flow as below:
  - hub_resume
    - usb_disable_interface
      - usb_disable_endpoint
        - usb_hcd_disable_endpoint
          - xhci_endpoint_disable  // it set @ep->hcpriv to NULL

Then when reset usb device, it will drop allocated endpoints,
the flow as below:
  - usb_reset_and_verify_device
    - usb_hcd_alloc_bandwidth
      - xhci_mtk_drop_ep

but @ep->hcpriv is already set to NULL, the bandwidth will be not
released anymore.

Due to the added endponts are stored in hash table, we can drop the check
of @ep->hcpriv.

Fixes: 4ce186665e7c ("usb: xhci-mtk: Do not use xhci's virt_dev in drop_endpoint")
Cc: stable <stable@kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20220819080556.32215-2-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -815,8 +815,8 @@ int xhci_mtk_drop_ep(struct usb_hcd *hcd
 	if (ret)
 		return ret;
 
-	if (ep->hcpriv)
-		drop_ep_quirk(hcd, udev, ep);
+	/* needn't check @ep->hcpriv, xhci_endpoint_disable set it NULL */
+	drop_ep_quirk(hcd, udev, ep);
 
 	return 0;
 }


