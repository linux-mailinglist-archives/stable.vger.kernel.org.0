Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8229024B49A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgHTKJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730802AbgHTKJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:09:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EE9F20724;
        Thu, 20 Aug 2020 10:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918165;
        bh=WomFmjj1uULt2FAPYNU8E1ci3xeQ1BiIwIHIHeGx9qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pES4sRLJi/lhwVlz4fwYL/LIpnb0AXgSFJ/M6GlaeAFVI2OGcZp61C/UqmdoUWUBv
         5ND5BY3kXdyhHKwc5T2Ec8Ar0FYJCmU4ZZti2ZTQFL8kQ3GeHuLRwyRwohK9pJ/924
         TeztIF+iC4oJZZhxr5acG93+R4INrNGIvSuiWyOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/228] usb: gadget: net2280: fix memory leak on probe error handling paths
Date:   Thu, 20 Aug 2020 11:20:50 +0200
Message-Id: <20200820091611.352461782@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 2468c877da428ebfd701142c4cdfefcfb7d4c00e ]

Driver does not release memory for device on error handling paths in
net2280_probe() when gadget_release() is not registered yet.

The patch fixes the bug like in other similar drivers.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/net2280.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 170327f84ea19..f1ac9a49e2bf1 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3786,8 +3786,10 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 done:
-	if (dev)
+	if (dev) {
 		net2280_remove(pdev);
+		kfree(dev);
+	}
 	return retval;
 }
 
-- 
2.25.1



