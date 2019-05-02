Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252C011F5B
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfEBPXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfEBPXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:23:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 755FA20B7C;
        Thu,  2 May 2019 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810627;
        bh=XIszzMle7hH7QFFSNuriAhew6Fm075CM15HW1boiOTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIahi+cOajvqvJcfMXa0cW0odYEuTDpI/n1INpGyA9ozA61CsxfaBLCEkXqBQBaTh
         CZznZCGdULifrfMG4auj7ninUTT89nHH+59bzNEe2n7e5FE4dBfTu/wO4H45SCZnx4
         GsAAjgCzRiY+QpzueZP7EakmItLNvHx5Pi2qnqu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 19/49] usb: gadget: net2272: Fix net2272_dequeue()
Date:   Thu,  2 May 2019 17:20:56 +0200
Message-Id: <20190502143326.478456131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 091dacc3cc10979ab0422f0a9f7fcc27eee97e69 ]

Restore the status of ep->stopped in function net2272_dequeue().

When the given request is not found in the endpoint queue
the function returns -EINVAL without restoring the state of
ep->stopped. Thus the endpoint keeps blocked and does not transfer
any data anymore.

This fix is only compile-tested, since we do not have a
corresponding hardware. An analogous fix was tested in the sibling
driver. See "usb: gadget: net2280: Fix net2280_dequeue()"

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/usb/gadget/udc/net2272.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/net2272.c b/drivers/usb/gadget/udc/net2272.c
index e0759a826b60..7fb31a3b53e6 100644
--- a/drivers/usb/gadget/udc/net2272.c
+++ b/drivers/usb/gadget/udc/net2272.c
@@ -958,6 +958,7 @@ net2272_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			break;
 	}
 	if (&req->req != _req) {
+		ep->stopped = stopped;
 		spin_unlock_irqrestore(&ep->dev->lock, flags);
 		return -EINVAL;
 	}
-- 
2.19.1



