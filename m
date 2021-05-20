Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5038A550
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhETKPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235587AbhETKMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D46A61440;
        Thu, 20 May 2021 09:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503842;
        bh=mvo2eDTKml7FAiVlgwLh2FbNba/I2yi4lzbUB1dhA+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sr14ew1oA5qJvGQSMJsSaoQ/ihogXqzo/VchFhRHuQP6Nmn0cL9VFcDy7pEpl6QPU
         214TJgzo9VRbGqlpzZCvhoWl1BOc71o1QJ/3yq0hLE/h5yD/9by/r5VWDpDzeXFUJ2
         3euJgWXVml/kYnezuWfC9ZbJKCHDGSAnAgC2o//k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 370/425] usb: fotg210-hcd: Fix an error message
Date:   Thu, 20 May 2021 11:22:19 +0200
Message-Id: <20210520092143.562695675@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a60a34366e0d09ca002c966dd7c43a68c28b1f82 ]

'retval' is known to be -ENODEV here.
This is a hard-coded default error code which is not useful in the error
message. Moreover, another error message is printed at the end of the
error handling path. The corresponding error code (-ENOMEM) is more
informative.

So remove simplify the first error message.

While at it, also remove the useless initialization of 'retval'.

Fixes: 7d50195f6c50 ("usb: host: Faraday fotg210-hcd driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/94531bcff98e46d4f9c20183a90b7f47f699126c.1620333419.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 2d5a72c15069..226b38274a6e 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -5569,7 +5569,7 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct resource *res;
 	int irq;
-	int retval = -ENODEV;
+	int retval;
 	struct fotg210_hcd *fotg210;
 
 	if (usb_disabled())
@@ -5589,7 +5589,7 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
 	hcd = usb_create_hcd(&fotg210_fotg210_hc_driver, dev,
 			dev_name(dev));
 	if (!hcd) {
-		dev_err(dev, "failed to create hcd with err %d\n", retval);
+		dev_err(dev, "failed to create hcd\n");
 		retval = -ENOMEM;
 		goto fail_create_hcd;
 	}
-- 
2.30.2



