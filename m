Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291DB240F0A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgHJTR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729962AbgHJTOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:14:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E5A022B47;
        Mon, 10 Aug 2020 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086848;
        bh=WomFmjj1uULt2FAPYNU8E1ci3xeQ1BiIwIHIHeGx9qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tVc6Ru7s9myWJPhnmv/iXN1WA/27rjwi9G3NEMHxhmqMb5VMc6hdcts7Ea8BzttG
         aIlzRYmDMF5Py1Xs0JuZS7yOtFi4yuAmjSNB60YzQt9x5L7VrRaiswApe7HjdKHOt/
         VWZFV2dDqo7D4W2Sz3UI6ka0YhMaauz/JPWhvxg0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/22] usb: gadget: net2280: fix memory leak on probe error handling paths
Date:   Mon, 10 Aug 2020 15:13:38 -0400
Message-Id: <20200810191345.3795166-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191345.3795166-1-sashal@kernel.org>
References: <20200810191345.3795166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

