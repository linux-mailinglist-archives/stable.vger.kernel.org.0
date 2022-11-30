Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602F363DEB5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiK3Sj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiK3Sjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:39:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F73B97021
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3B4BB81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B32C433C1;
        Wed, 30 Nov 2022 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833591;
        bh=s7jnFt+6J9SYttFmMJAARHk/bNOYKCTxCOe0Ifh8rgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IC/RCcVEbJnrtTC4H6GlLi7I6qGZixgBbvHJofQEDbcJcoJcFuHbxgGLQfGH8uPFW
         QEHJ6pBGEZPSsS1SuuYD2IhV7ll3DPIBkNMRDMMARsSBgkhbO4Vffv+SPCaeK3EYwT
         /yBGbBuqKKwwcyzv1SLYRIJpkexw8y5t9GLqsuRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/206] usb: dwc3: gadget: Clear ep descriptor last
Date:   Wed, 30 Nov 2022 19:23:24 +0100
Message-Id: <20221130180536.902621081@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit f90f5afd5083a7cb4aee13bd4cc0ae600bd381ca ]

Until the endpoint is disabled, its descriptors should remain valid.
When its requests are removed from ep disable, the request completion
routine may attempt to access the endpoint's descriptor. Don't clear the
descriptors before that.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/45db7c83b209259115bf652af210f8b2b3b1a383.1668561364.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 515ace4c85cf..dfa1d9eedde1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1002,18 +1002,18 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	/* Clear out the ep descriptors for non-ep0 */
-	if (dep->number > 1) {
-		dep->endpoint.comp_desc = NULL;
-		dep->endpoint.desc = NULL;
-	}
-
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
 	dep->type = 0;
 	dep->flags &= DWC3_EP_TXFIFO_RESIZED;
 
+	/* Clear out the ep descriptors for non-ep0 */
+	if (dep->number > 1) {
+		dep->endpoint.comp_desc = NULL;
+		dep->endpoint.desc = NULL;
+	}
+
 	return 0;
 }
 
-- 
2.35.1



