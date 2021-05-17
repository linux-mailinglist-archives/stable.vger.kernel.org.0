Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C523836B2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbhEQPfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245025AbhEQPcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F0F61CCE;
        Mon, 17 May 2021 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262326;
        bh=4VmMxC+e+Hz6FH+qIsqesV5a2Jh7fJYo4OHneZ9G1qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np63jMpRjeBLKr0qsei+ypwT+thk+C+sOfWKTgc1WpYwjNw/zOfS9WvIukKKQBqW1
         OiwKUrvAi87pN+1gLe+keDjNN0p1qoBKG3w2ftq5LI6B/N13Hy5q22fqYYgEjKftRm
         ejuU5wGaLFWDC+xYnBL7B7QckLPCJ4LP5/2+VKuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 265/329] usb: fotg210-hcd: Fix an error message
Date:   Mon, 17 May 2021 16:02:56 +0200
Message-Id: <20210517140311.075538406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 5617ef30530a..f0e4a315cc81 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -5568,7 +5568,7 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct resource *res;
 	int irq;
-	int retval = -ENODEV;
+	int retval;
 	struct fotg210_hcd *fotg210;
 
 	if (usb_disabled())
@@ -5588,7 +5588,7 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
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



