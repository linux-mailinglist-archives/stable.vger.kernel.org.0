Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FCB14F01
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfEFOhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfEFOhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DCCC204EC;
        Mon,  6 May 2019 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153432;
        bh=dONN9DZiWm0DxeP39EVsGqhgAn8epP3pcjSbJ8wX0jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykHBRGXGU272QHHZFGhjtAw5+1kOXxLyJJ2ByvgcyPO00mIq0ZBf3Q1USLJtwGP0/
         Nb3hxiZqPjx1GVUJ+koBwxOC9SntEfjUp1HvD9CIQNobnjIaPGw7V6tiSV8BWq09R7
         hUvitYp5oPSSn53rllt5fCQLIkTw38pushj22xtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.0 087/122] usb: dwc3: Reset num_trbs after skipping
Date:   Mon,  6 May 2019 16:32:25 +0200
Message-Id: <20190506143102.546646600@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <thinh.nguyen@synopsys.com>

commit c7152763f02e05567da27462b2277a554e507c89 upstream.

Currently req->num_trbs is not reset after the TRBs are skipped and
processed from the cancelled list. The gadget driver may reuse the
request with an invalid req->num_trbs, and DWC3 will incorrectly skip
trbs. To fix this, simply reset req->num_trbs to 0 after skipping
through all of them.

Fixes: c3acd5901414 ("usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1506,6 +1506,8 @@ static void dwc3_gadget_ep_skip_trbs(str
 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 		dwc3_ep_inc_deq(dep);
 	}
+
+	req->num_trbs = 0;
 }
 
 static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)


