Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6572F43A816
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 01:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhJYXXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 19:23:35 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:32780 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233776AbhJYXXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 19:23:34 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AD8AA40D78;
        Mon, 25 Oct 2021 23:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1635204071; bh=KB/1FEnjZLxJUWtECG4jywDXWMIf809/048iIBuY4kw=;
        h=Date:From:Subject:To:Cc:From;
        b=jY40RNtLwBhv3YqbTPCaMP057RHPE57HaHuMnA/hUlhPPPkFWWVMILzV7AjxChPVs
         DLYT/9rC2Lh4iO44LgNgn+0xu3WzFyHOW39epOWAVkwE0LWoCOhbeG9cciRHHBrdHB
         FhK0bocyM6ft0r9YoujF7HRQ8slgB76AQEdEPSNvbeMxeAlYrM+PkvLBcO6lC7aYr2
         uWfZ77pdhfa0GYiUqtDRnq1ZLn/KOZ5foYCz6RwNs6hzG/eTvgeiTysUkauc1+W/+T
         t/rX6fO/MhWKSsO0Kz7DO5pAfWWNh9x2myRIX7N++AdmwKRmLLrEsMenV35yVCJsEk
         rjBUxzEFt7NJQ==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 893E1A0096;
        Mon, 25 Oct 2021 23:21:10 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 25 Oct 2021 16:21:10 -0700
Date:   Mon, 25 Oct 2021 16:21:10 -0700
Message-Id: <cee1253af4c3600edb878d11c9c08b040817ae23.1635203975.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Ignore NoStream after End Transfer
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The End Transfer command from a stream endpoint will generate a NoStream
event, and we should ignore it. Currently we set the flag
DWC3_EP_IGNORE_NEXT_NOSTREAM to track this prior to sending the command,
and it will be cleared on the next stream event. However, a stream event
may be generated before the End Transfer command completion and
prematurely clear the flag. Fix this by setting the flag on End Transfer
completion instead.

Cc: <stable@vger.kernel.org>
Fixes: 140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 23de2a5a40d6..3d6f4adaa15a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3352,6 +3352,14 @@ static void dwc3_gadget_endpoint_command_complete(struct dwc3_ep *dep,
 	if (cmd != DWC3_DEPCMD_ENDTRANSFER)
 		return;
 
+	/*
+	 * The END_TRANSFER command will cause the controller to generate a
+	 * NoStream Event, and it's not due to the host DP NoStream rejection.
+	 * Ignore the next NoStream event.
+	 */
+	if (dep->stream_capable)
+		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
+
 	dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 	dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	dwc3_gadget_ep_cleanup_cancelled_requests(dep);
@@ -3574,14 +3582,6 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	/*
-	 * The END_TRANSFER command will cause the controller to generate a
-	 * NoStream Event, and it's not due to the host DP NoStream rejection.
-	 * Ignore the next NoStream event.
-	 */
-	if (dep->stream_capable)
-		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
-
 	if (!interrupt)
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	else

base-commit: e8d6336d9d7198013a7b307107908242a7a53b23
-- 
2.28.0

