Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE01EF03E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfKDVuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbfKDVux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:50:53 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2531D21D71;
        Mon,  4 Nov 2019 21:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904252;
        bh=0RUSc03uHfSvyypp3INuX99FfiD3jlpxtsAtyT7UMR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETdyiv6Mr6D66n/nvah0oSvPzi4R5KGmlrLkWi48K0KTl9MNno9G4CfZpLN6cjbLl
         96osaK6I9SWAugFqSo19mZP4QhjqQTjIHgVQVuz495De7gwBFSxEwedk5TiKAHKFT9
         nLwdCkdZifOBDDaeltsvkWm0HcSksWMK5Hw6VqZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@kernel.org>,
        syzbot+8ab8bf161038a8768553@syzkaller.appspotmail.com
Subject: [PATCH 4.9 38/62] USB: gadget: Reject endpoints with 0 maxpacket value
Date:   Mon,  4 Nov 2019 22:45:00 +0100
Message-Id: <20191104211941.314059122@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
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
@@ -106,6 +106,17 @@ int usb_ep_enable(struct usb_ep *ep)
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


