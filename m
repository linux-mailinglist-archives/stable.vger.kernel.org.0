Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0321F9C6
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgGNSq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbgGNSqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:46:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AE222282;
        Tue, 14 Jul 2020 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752384;
        bh=MSXNpAEhno4g986D8o9A5a+ESTpY1tYD20T+D+8C4+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR2tWKGpMriZmMXSdsK5yyvVMIzCJYbKOoCQZyxXERiyED+Norp0ILJ0pol7PAMtf
         B1S0Zy5RbhSxfxSK8qwvMnI+iBoFvSw03EgXcH4xAeZHgYTE8Pw620DZl8aJDKrw+R
         0ozyOTCYmHtBAPrWzedtHuP1B4Vem9a90hFgNQIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/58] usb: dwc3: pci: Fix reference count leak in dwc3_pci_resume_work
Date:   Tue, 14 Jul 2020 20:43:54 +0200
Message-Id: <20200714184057.196831279@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 2655971ad4b34e97dd921df16bb0b08db9449df7 ]

dwc3_pci_resume_work() calls pm_runtime_get_sync() that increments
the reference counter. In case of failure, decrement the reference
before returning.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index b2fd505938a0c..389ec4c689c44 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -204,8 +204,10 @@ static void dwc3_pci_resume_work(struct work_struct *work)
 	int ret;
 
 	ret = pm_runtime_get_sync(&dwc3->dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync_autosuspend(&dwc3->dev);
 		return;
+	}
 
 	pm_runtime_mark_last_busy(&dwc3->dev);
 	pm_runtime_put_sync_autosuspend(&dwc3->dev);
-- 
2.25.1



