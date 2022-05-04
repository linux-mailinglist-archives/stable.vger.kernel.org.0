Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313F851A915
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351287AbiEDRMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356843AbiEDRJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E2640A1E;
        Wed,  4 May 2022 09:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF1A0616F8;
        Wed,  4 May 2022 16:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD10C385AA;
        Wed,  4 May 2022 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683356;
        bh=GYqdHF/kWbxCt6a86UWjM3QOO2fhmQgGD64+8+8qvrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxndevaQjYAPC7wPE/YFoReh99w4A/be34cHyIlXkMvmmjXL8VuEOPehFaJMb9g/K
         4b7VePrOMKn18dsdAM3RHtxuRqR5QnAd1AoLwQMYhapNOpIn+m/D+Bv13zpJ3TVuvn
         UnwvCDQoU0aVOdrYv+4ajSUiLKt3QbMMuyFCtpe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.17 029/225] usb: cdns3: Fix issue for clear halt endpoint
Date:   Wed,  4 May 2022 18:44:27 +0200
Message-Id: <20220504153112.887225733@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit b3fa25de31fb7e9afebe9599b8ff32eda13d7c94 upstream.

Path fixes bug which occurs during resetting endpoint in
__cdns3_gadget_ep_clear_halt function. During resetting endpoint
controller will change HW/DMA owned TRB. It set Abort flag in
trb->control and will change trb->length field. If driver want
to use the aborted trb it must update the changed field in
TRB.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220329084605.4022-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2684,6 +2684,7 @@ int __cdns3_gadget_ep_clear_halt(struct
 	struct usb_request *request;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *trb = NULL;
+	struct cdns3_trb trb_tmp;
 	int ret;
 	int val;
 
@@ -2693,8 +2694,10 @@ int __cdns3_gadget_ep_clear_halt(struct
 	if (request) {
 		priv_req = to_cdns3_request(request);
 		trb = priv_req->trb;
-		if (trb)
+		if (trb) {
+			trb_tmp = *trb;
 			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+		}
 	}
 
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
@@ -2709,7 +2712,7 @@ int __cdns3_gadget_ep_clear_halt(struct
 
 	if (request) {
 		if (trb)
-			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+			*trb = trb_tmp;
 
 		cdns3_rearm_transfer(priv_ep, 1);
 	}


