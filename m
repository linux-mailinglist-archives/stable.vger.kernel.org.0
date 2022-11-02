Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704A3615A5A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiKBD3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiKBD3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0DD26490
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:29:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF063617D4
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E665C433C1;
        Wed,  2 Nov 2022 03:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359761;
        bh=FyvPlpWbI4NYcf1+wu9z4O0d/W9uaa4MgpDeORfYYFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7RO7gmq0N+T6y99uPyYEp+m8oOhhE6gJ0y0ntt4Xv63Vbgw2jGHNxYZJ2M0qoAdD
         BbqFubEhQozi3ebxEU91MX6+439RBfgT1Emevjp2Fj7TG8hpjST2Ln36mx/7X2vVVG
         1yXgVkU+s6ht4GsGFo57dMxfAnWhUMERMa5fXi5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 30/78] usb: dwc3: gadget: Stop processing more requests on IMI
Date:   Wed,  2 Nov 2022 03:34:15 +0100
Message-Id: <20221102022053.877852735@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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

commit f78961f8380b940e0cfc7e549336c21a2ad44f4d upstream.

When servicing a transfer completion event, the dwc3 driver will reclaim
TRBs of started requests up to the request associated with the interrupt
event. Currently we don't check for interrupt due to missed isoc, and
the driver may attempt to reclaim TRBs beyond the associated event. This
causes invalid memory access when the hardware still owns the TRB. If
there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
to stop servicing further.

Note that only the last TRB of chained TRBs has its status updated with
missed isoc.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
Reported-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
Link: https://lore.kernel.org/r/b29acbeab531b666095dfdafd8cb5c7654fbb3e1.1666735451.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2363,6 +2363,10 @@ static int dwc3_gadget_ep_reclaim_comple
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;


