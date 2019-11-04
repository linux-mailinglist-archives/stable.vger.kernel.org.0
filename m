Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C61EECA4
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfKDV7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbfKDV7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:07 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2B5214E0;
        Mon,  4 Nov 2019 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904746;
        bh=1+u1DkWnQPvDJmZtTN8GhHQZL6ffowQ+Ec2hlERuOeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Npxs0+x8K0CdnJVgiM5+MBgRQUVdRxjboJ7dcSRwjB3Z+pRzP4hYbKPbP2Sb376Z3
         CVQ02Go3G98HqOA6W6j6+3mHumed7afF7Ivuvs/EKMRghqLwfbT7QUefcRYx/m/nto
         h4eBCXgwOskQWUIsV5jTU/BlXRx+nqSGa8ddQcqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/149] usb: dwc3: gadget: early giveback if End Transfer already completed
Date:   Mon,  4 Nov 2019 22:43:51 +0100
Message-Id: <20191104212138.439588864@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[ Upstream commit 9f45581f5eec6786c6eded2b3c85345d82a910c9 ]

There is a rare race condition that may happen during a Disconnect
Interrupt if we have a started request that happens to be
dequeued *after* completion of End Transfer command. If that happens,
that request will be left waiting for completion of an End Transfer
command that will never happen.

If End Transfer command has already completed before, we are safe to
giveback the request straight away.

Tested-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e7461c995116a..7b0957c530485 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1410,7 +1410,10 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 				goto out0;
 
 			dwc3_gadget_move_cancelled_request(req);
-			goto out0;
+			if (dep->flags & DWC3_EP_TRANSFER_STARTED)
+				goto out0;
+			else
+				goto out1;
 		}
 		dev_err(dwc->dev, "request %pK was not queued to %s\n",
 				request, ep->name);
@@ -1418,6 +1421,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		goto out0;
 	}
 
+out1:
 	dwc3_gadget_giveback(dep, req, -ECONNRESET);
 
 out0:
-- 
2.20.1



