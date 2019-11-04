Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5FEEFAA
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388079AbfKDVzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388075AbfKDVzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:03 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D375521929;
        Mon,  4 Nov 2019 21:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904503;
        bh=TCD15nTPiNtVzoGzFyyq+5AJZ5kZN2CFBw3fYkMHemc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfrLZ5Xj8QQpu264sp0VlPrXu0Ryw3GFq/psusKpAVr1+J3WPWcbe89hoj1ci+C4c
         XbtT8kpAHf4XZv5wBF4od6Sv6s6OgJJLnGwS/0ufLvSl+ijdfB1MIsbHXdPh/2Gy4o
         VqQNryfXHrzKSKbV6UuR4zy79HAH0ALhqwoSwUCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@kernel.org>,
        syzbot+8ab8bf161038a8768553@syzkaller.appspotmail.com
Subject: [PATCH 4.14 68/95] USB: gadget: Reject endpoints with 0 maxpacket value
Date:   Mon,  4 Nov 2019 22:45:06 +0100
Message-Id: <20191104212112.161133115@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 54f83b8c8ea9b22082a496deadf90447a326954e upstream.

Endpoints with a maxpacket length of 0 are probably useless.  They
can't transfer any data, and it's not at all unlikely that a UDC will
crash or hang when trying to handle a non-zero-length usb_request for
such an endpoint.  Indeed, dummy-hcd gets a divide error when trying
to calculate the remainder of a transfer length by the maxpacket
value, as discovered by the syzbot fuzzer.

Currently the gadget core does not check for endpoints having a
maxpacket value of 0.  This patch adds a check to usb_ep_enable(),
preventing such endpoints from being used.

As far as I know, none of the gadget drivers in the kernel tries to
create an endpoint with maxpacket = 0, but until now there has been
nothing to prevent userspace programs under gadgetfs or configfs from
doing it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+8ab8bf161038a8768553@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1910281052370.1485-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -107,6 +107,17 @@ int usb_ep_enable(struct usb_ep *ep)
 	if (ep->enabled)
 		goto out;
 
+	/* UDC drivers can't handle endpoints with maxpacket size 0 */
+	if (usb_endpoint_maxp(ep->desc) == 0) {
+		/*
+		 * We should log an error message here, but we can't call
+		 * dev_err() because there's no way to find the gadget
+		 * given only ep.
+		 */
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = ep->ops->enable(ep, ep->desc);
 	if (ret)
 		goto out;


