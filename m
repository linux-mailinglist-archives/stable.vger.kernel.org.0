Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1017F6159F3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKBDV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiKBDVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:21:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380C825C5E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D87B0B82055
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B01C433D7;
        Wed,  2 Nov 2022 03:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359289;
        bh=9W6ezmOLbDz3LqOieQLvDR3IxuUFZE/rinyiVnz/dOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSYVdICOQR2N6ngC1bJbv72RH8JxjQbCMJ1KsRYYaxiJE/w2OEvuc51H53bOVXvvz
         avMruE8Swuj5bgtJCOKpUVhXZSZ0yFaVh2VY5Z9dkVOGX1SX/UsXQR/Cp480/QN6Y8
         Acy+/Vjy6cRMWup4ReTr2tPk6gQVaft8zxXvVsjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <jdv1029@gmail.com>
Subject: [PATCH 5.4 07/64] usb: dwc3: gadget: Dont set IMI for no_interrupt
Date:   Wed,  2 Nov 2022 03:33:33 +0100
Message-Id: <20221102022052.057727826@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 308c316d16cbad99bb834767382baa693ac42169 upstream.

The gadget driver may have a certain expectation of how the request
completion flow should be from to its configuration. Make sure the
controller driver respect that. That is, don't set IMI (Interrupt on
Missed Isoc) when usb_request->no_interrupt is set. Also, the driver
should only set IMI to the last TRB of a chain.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
Link: https://lore.kernel.org/r/ced336c84434571340c07994e3667a0ee284fefe.1666735451.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -981,8 +981,8 @@ static void __dwc3_prepare_one_trb(struc
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:


