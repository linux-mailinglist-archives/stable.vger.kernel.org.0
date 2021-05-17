Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F46E383516
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbhEQPQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243030AbhEQPMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EEC1611CC;
        Mon, 17 May 2021 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261895;
        bh=EIXrZA+xX40Oh/z8XAIFBwLcrRj8ninqvNPLsYrmQOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaFNaRBPWQhxzZyUMglyJGOqEeiLKMqKeTDbbPmSE5pZ3p/exzGijVoL3XhX+q8XL
         PdfD7wqozSU3ddDhfiWz+5J6XYrH0/srfGiHx+oYXkMc0RQ0765IRbKzu4z75E+0Pg
         3SftUvHQfBkPEAdFu7m3kMrO4CYUkAEI59KYnWCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/141] usb: fotg210-hcd: Fix an error message
Date:   Mon, 17 May 2021 16:02:38 +0200
Message-Id: <20210517140246.361331999@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index 9e0c98d6bdb0..c3f74d6674e1 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -5571,7 +5571,7 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct resource *res;
 	int irq;
-	int retval = -ENODEV;
+	int retval;
 	struct fotg210_hcd *fotg210;
 
 	if (usb_disabled())
@@ -5591,7 +5591,7 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
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



