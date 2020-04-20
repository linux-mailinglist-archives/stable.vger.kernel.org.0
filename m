Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73331B0BCE
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgDTMmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgDTMmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03EC20724;
        Mon, 20 Apr 2020 12:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386563;
        bh=bCDq43JudMUVyE16zfPz7jVRgValKuqje5YUNUC1vdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdT6OaiSPipye3qWDUemA13IZXpQCUMgGF0W4qLojbu17Cb1L6i2qlN6wv9n3WbNQ
         1Fs/FfiGG2bTWLbUUAPOOd0sZ5eN9eSgTveX5BIIuXxyj6mpCmIstjpvbPMEKObCCV
         ojMyfoAFKUDqSlPtMGzMMRAGBdbawyelU+khux/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.5 37/65] usb: dwc3: gadget: Dont clear flags before transfer ended
Date:   Mon, 20 Apr 2020 14:38:41 +0200
Message-Id: <20200420121514.336991863@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit a114c4ca64bd522aec1790c7e5c60c882f699d8f upstream.

We track END_TRANSFER command completion. Don't clear transfer
started/ended flag prematurely. Otherwise, we'd run into the problem
with restarting transfer before END_TRANSFER command finishes.

Fixes: 6d8a019614f3 ("usb: dwc3: gadget: check for Missed Isoc from event status")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2567,10 +2567,8 @@ static void dwc3_gadget_endpoint_transfe
 
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
-	if (stop) {
+	if (stop)
 		dwc3_stop_active_transfer(dep, true, true);
-		dep->flags = DWC3_EP_ENABLED;
-	}
 
 	/*
 	 * WORKAROUND: This is the 2nd half of U1/U2 -> U0 workaround.


