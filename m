Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1DC55E0D3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbiF1BlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 21:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiF1BlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 21:41:22 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6705D1CB3F;
        Mon, 27 Jun 2022 18:41:22 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9F862C0C37;
        Tue, 28 Jun 2022 01:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1656380482; bh=nDe1NAPFG1OXsSFmVheJ76A7Su8wzpWVVIvqwyJaOT4=;
        h=Date:From:Subject:To:Cc:From;
        b=IAILDbeLX7dd1x84KbyqqaYymkq5KAj4qcvQwVpkTtclQOt33xxxMN9wDbCv3BfOV
         345/rq8adLsqPNLZzc8srW7JpWU7qBqn0WotTyczC12cPAFvzc0zcrm1sRz2hnyAW9
         a9LmnHhwnkRONksS6Nx5w0YtQHvHYTaFdg5EbXlyXoXwTdwat4DkYxSc3L+klWs6Uz
         TUMqbPYe7hsN0ybGbMO15wHzhwmPVx7DPygqFdQt67q/0+TluxryIWtDMmGEpPtoey
         wzSwf6cKVm7cEaPDXVGbwMPO11M3vePXp9oBviM3Pb66cgr/lgcvBzCxHK8dPTvuyJ
         65JGv6cPqVDyg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 91759A0076;
        Tue, 28 Jun 2022 01:41:19 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 27 Jun 2022 18:41:19 -0700
Date:   Mon, 27 Jun 2022 18:41:19 -0700
Message-Id: <8670aaf1cf52e7d1e6df2a827af2d77263b93b75.1656380429.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Fix event pending check
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/dwc3/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8716bece1072..0d89dfa6eef5 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4249,7 +4249,6 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 	}
 
 	evt->count = 0;
-	evt->flags &= ~DWC3_EVENT_PENDING;
 	ret = IRQ_HANDLED;
 
 	/* Unmask interrupt */
@@ -4261,6 +4260,9 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 		dwc3_writel(dwc->regs, DWC3_DEV_IMOD(0), dwc->imod_interval);
 	}
 
+	/* Keep the clearing of DWC3_EVENT_PENDING at the end */
+	evt->flags &= ~DWC3_EVENT_PENDING;
+
 	return ret;
 }
 

base-commit: 03c765b0e3b4cb5063276b086c76f7a612856a9a
-- 
2.28.0

