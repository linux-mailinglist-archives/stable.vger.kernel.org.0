Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF413579A5F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiGSMOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiGSMNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:13:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C830760FF;
        Tue, 19 Jul 2022 05:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 318D461732;
        Tue, 19 Jul 2022 12:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D70EC341C6;
        Tue, 19 Jul 2022 12:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232253;
        bh=6nPWF2mFHyLLOLlwlror3SKJTBcLQQVTHBzTqHmHZtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAclvhSW/qZVU/PNkIbXEmfoEP0DroKYeIzsXg18p00KXq9x5x66aahZBZamyAw1v
         sROE47mxEoL7zQd6AxdSpQ2L19Pxe8lGLAEZoPvdJXw0rxbfOO3/j2R6gLZP1uPWdD
         Mpb+uqHDBN76ro7Mtj8YRUCdZg4mTAG77n50DaVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 66/71] usb: dwc3: gadget: Fix event pending check
Date:   Tue, 19 Jul 2022 13:54:29 +0200
Message-Id: <20220719114558.955191403@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 7441b273388b9a59d8387a03ffbbca9d5af6348c upstream.

The DWC3_EVENT_PENDING flag is used to protect against invalid call to
top-half interrupt handler, which can occur when there's a delay in
software detection of the interrupt line deassertion.

However, the clearing of this flag was done prior to unmasking the
interrupt line, creating opportunity where the top-half handler can
come. This breaks the serialization and creates a race between the
top-half and bottom-half handler, resulting in losing synchronization
between the controller and the driver when processing events.

To fix this, make sure the clearing of the DWC3_EVENT_PENDING is done at
the end of the bottom-half handler.

Fixes: d325a1de49d6 ("usb: dwc3: gadget: Prevent losing events in event cache")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/8670aaf1cf52e7d1e6df2a827af2d77263b93b75.1656380429.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3535,7 +3535,6 @@ static irqreturn_t dwc3_process_event_bu
 	}
 
 	evt->count = 0;
-	evt->flags &= ~DWC3_EVENT_PENDING;
 	ret = IRQ_HANDLED;
 
 	/* Unmask interrupt */
@@ -3548,6 +3547,9 @@ static irqreturn_t dwc3_process_event_bu
 		dwc3_writel(dwc->regs, DWC3_DEV_IMOD(0), dwc->imod_interval);
 	}
 
+	/* Keep the clearing of DWC3_EVENT_PENDING at the end */
+	evt->flags &= ~DWC3_EVENT_PENDING;
+
 	return ret;
 }
 


