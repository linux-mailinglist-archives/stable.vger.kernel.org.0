Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4C3F7F24
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfKKSem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfKKSel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E062184C;
        Mon, 11 Nov 2019 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497280;
        bh=u2WiRRQuim1fNDHS1TtGI7F5skQJaI+p4MRwZPmLl5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIkOyYweziXWGOGFn1HMbrfTfeooCgcIFsbutxb8/6k+wIYzI7CJVJ7XloYXf8KCb
         rjynH1o3sWHocup5xIEeR0S1d2BMKHQFcvgwt9OQIxDT8LwqwsQbRfbgIvaVWjtP2m
         dWyR2j6b4/rx89yYokAvGsz4jtnD+03qzgb4+kBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 51/65] USB: Skip endpoints with 0 maxpacket length
Date:   Mon, 11 Nov 2019 19:28:51 +0100
Message-Id: <20191111181351.189411366@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit d482c7bb0541d19dea8bff437a9f3c5563b5b2d2 ]

Endpoints with a maxpacket length of 0 are probably useless.  They
can't transfer any data, and it's not at all unlikely that an HCD will
crash or hang when trying to handle an URB for such an endpoint.

Currently the USB core does not check for endpoints having a maxpacket
value of 0.  This patch adds a check, printing a warning and skipping
over any endpoints it catches.

Now, the USB spec does not rule out endpoints having maxpacket = 0.
But since they wouldn't have any practical use, there doesn't seem to
be any good reason for us to accept them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1910281050420.1485-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 94ec2dc27748e..e8061b02b7e3b 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -343,6 +343,11 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
 
 	/* Validate the wMaxPacketSize field */
 	maxp = usb_endpoint_maxp(&endpoint->desc);
+	if (maxp == 0) {
+		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has wMaxPacketSize 0, skipping\n",
+		    cfgno, inum, asnum, d->bEndpointAddress);
+		goto skip_to_next_endpoint_or_interface_descriptor;
+	}
 
 	/* Find the highest legal maxpacket size for this endpoint */
 	i = 0;		/* additional transactions per microframe */
-- 
2.20.1



