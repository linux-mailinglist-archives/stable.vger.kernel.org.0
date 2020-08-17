Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD42476EC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgHQTmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgHQPYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:24:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C805620825;
        Mon, 17 Aug 2020 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677841;
        bh=SNx4u4/k2IbtAP3EPJ8PZIqvxZtBKRyULR07bQ8PFZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfOCr27f3UMatbgw03JKjM9YjI7noc6u+pRyLe1PT7XEW9ACRPgSvMVlYi8WG0LRc
         vRl58h56BcqWrkkCrXTeptMpywNrV3WeL4tM5Ym3QUbN49y4EoXrJR6vNn6ILcjl2G
         1MDRBN0jeV2YOfMCylldQVKiBLIh9cp2pso+thL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 128/464] usb: gadget: net2280: fix memory leak on probe error handling paths
Date:   Mon, 17 Aug 2020 17:11:21 +0200
Message-Id: <20200817143839.943085106@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 5eff85eeaa5a0..7530bd9a08c43 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3781,8 +3781,10 @@ static int net2280_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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



