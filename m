Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C68059A0C2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350086AbiHSPxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350002AbiHSPwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426E3106B3D;
        Fri, 19 Aug 2022 08:49:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 324B7616B3;
        Fri, 19 Aug 2022 15:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCF6C433C1;
        Fri, 19 Aug 2022 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924143;
        bh=71bTs8+DdYlyzXQOg/QtkRrEs67hwsdiz1TizUPSiqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZfy+/emT5w9LzS9DS/SxEG382MtR2v5B9SQGjcoZjaTmxocMGTu+DN5SiqN/Fp9F
         b+UbnxDto1YCi39gljSIOboV31KUAIGORun2q6wLRBVesaQ37wgQ5km2/F3EiZNgFv
         ZyNXOs75HwgIQSRz9NI1GP/x2bAwD2/fxRI6v9ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 5.10 070/545] usb: dwc3: gadget: fix high speed multiplier setting
Date:   Fri, 19 Aug 2022 17:37:20 +0200
Message-Id: <20220819153832.380922840@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 8affe37c525d800a2628c4ecfaed13b77dc5634a upstream.

For High-Speed Transfers the prepare_one_trb function is calculating the
multiplier setting for the trb based on the length parameter of the trb
currently prepared. This assumption is wrong. For trbs with a sg list,
the length of the actual request has to be taken instead.

Fixes: 40d829fb2ec6 ("usb: dwc3: gadget: Correct ISOC DATA PIDs for short packets")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220704141812.1532306-3-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1052,10 +1052,10 @@ static void dwc3_prepare_one_trb(struct
 				unsigned int mult = 2;
 				unsigned int maxp = usb_endpoint_maxp(ep->desc);
 
-				if (trb_length <= (2 * maxp))
+				if (req->request.length <= (2 * maxp))
 					mult--;
 
-				if (trb_length <= maxp)
+				if (req->request.length <= maxp)
 					mult--;
 
 				trb->size |= DWC3_TRB_SIZE_PCM1(mult);


