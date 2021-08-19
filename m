Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390793F0FE0
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 03:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhHSBRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 21:17:40 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:60154 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232954AbhHSBRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 21:17:40 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 602884646B;
        Thu, 19 Aug 2021 01:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1629335824; bh=ncCJBhXMOwTrEGT4+Q7v6Zd09/ZSBnkR0TFa1Tj1fmc=;
        h=Date:From:Subject:To:Cc:From;
        b=cCcHW23z66MkZIVvaQRlZG/Fr17U/FTb/trH7iGay288G2elC/bSpO5MHskRX2PB3
         XnhBiTieJFjb1aOOMu7Sv2aT6V6EM3LR3Typ23ZWDSxmqLCVsRDhBn4i6fbSeWWMS8
         pU7+WdjXE+1GoOjO0owzBP/DxafYwVpczfNvidZeDUP4rZU1zAqWGoIZCGfnfpmHZD
         9VitPC2wtnYMD7u8YO2v7/wpuQyRXUUiHbvLioF8f2fEjR9HPHIAshfgWn/fA7u2GW
         dmLYjqDEXWv/vsGRq2VxujV2PELf0IVFypIxKO7q6OXYdfohpNHNUL3xuS0Y+jDG7U
         5yeYZr7zEkOKg==
Received: from te-lab15 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 378B6A00E0;
        Thu, 19 Aug 2021 01:17:03 +0000 (UTC)
Received: by te-lab15 (sSMTP sendmail emulation); Thu, 19 Aug 2021 03:17:03 +0200
Date:   Thu, 19 Aug 2021 03:17:03 +0200
Message-Id: <e91e975affb0d0d02770686afc3a5b9eb84409f6.1629335416.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Fix dwc3_calc_trbs_left()
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can't depend on the TRB's HWO bit to determine if the TRB ring is
"full". A TRB is only available when the driver had processed it, not
when the controller consumed and relinquished the TRB's ownership to the
driver. Otherwise, the driver may overwrite unprocessed TRBs. This can
happen when many transfer events accumulate and the system is slow to
process them and/or when there are too many small requests.

If a request is in the started_list, that means there is one or more
unprocessed TRBs remained. Check this instead of the TRB's HWO bit
whether the TRB ring is full.

Cc: <stable@vger.kernel.org>
Fixes: c4233573f6ee ("usb: dwc3: gadget: prepare TRBs on update transfers too")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 84fe57ef5a49..1e6ddbc986ba 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -940,19 +940,19 @@ static struct dwc3_trb *dwc3_ep_prev_trb(struct dwc3_ep *dep, u8 index)
 
 static u32 dwc3_calc_trbs_left(struct dwc3_ep *dep)
 {
-	struct dwc3_trb		*tmp;
 	u8			trbs_left;
 
 	/*
-	 * If enqueue & dequeue are equal than it is either full or empty.
-	 *
-	 * One way to know for sure is if the TRB right before us has HWO bit
-	 * set or not. If it has, then we're definitely full and can't fit any
-	 * more transfers in our ring.
+	 * If the enqueue & dequeue are equal then the TRB ring is either full
+	 * or empty. It's considered full when there are DWC3_TRB_NUM-1 of TRBs
+	 * pending to be processed by the driver.
 	 */
 	if (dep->trb_enqueue == dep->trb_dequeue) {
-		tmp = dwc3_ep_prev_trb(dep, dep->trb_enqueue);
-		if (tmp->ctrl & DWC3_TRB_CTRL_HWO)
+		/*
+		 * If there is any request remained in the started_list at
+		 * this point, that means there is no TRB available.
+		 */
+		if (!list_empty(&dep->started_list))
 			return 0;
 
 		return DWC3_TRB_NUM - 1;

base-commit: 5571ea3117ca22849072adb58074fb5a2fd12c00
-- 
2.28.0

