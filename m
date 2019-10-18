Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9FBDD3F2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfJRWVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731221AbfJRWGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11C6B222C6;
        Fri, 18 Oct 2019 22:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436377;
        bh=1+u1DkWnQPvDJmZtTN8GhHQZL6ffowQ+Ec2hlERuOeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5d0g8Q1BYteq+sN4xx68E/aZAINGCm1HBHORF7qNk/I9EJ92ty5gJcFVUffPzfo/
         bvTONBSTvAY7AMStiFtS6Msqv9WSXWQMFEXfLH24kLKTe0viAyP74FGcvHDaUyVc14
         kwF5fqbcpTROoQ3CXB0VBKOxaukGxsmEDz7KdB+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 031/100] usb: dwc3: gadget: early giveback if End Transfer already completed
Date:   Fri, 18 Oct 2019 18:04:16 -0400
Message-Id: <20191018220525.9042-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

