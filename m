Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A908113152
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfLDR6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbfLDR6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:58:18 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F462073B;
        Wed,  4 Dec 2019 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482297;
        bh=2GEVP+XTklP07ZP2wt7K2gymaaWsRpRrMdsz26QNACk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bd23QiyIciyPOG431l1iwMsRZ78yjlzxmbVHrxu3rlxv/O1GAc0e7naZwGpzaQpge
         YwkulK2ULvZPM0YEyMzQG2Hib7STPK4jVAPM8YUvnarZDTtsZ3PoOuSLQvsGHkEe1F
         C6Y1f7Qxq+pgiMH517oj6fZrDJ7p15FBZIbMJOkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/92] xen/pciback: Check dev_data before using it
Date:   Wed,  4 Dec 2019 18:49:30 +0100
Message-Id: <20191204174332.418933245@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 1669907e3d1abfa3f7586e2d55dbbc117b5adba2 ]

If pcistub_init_device fails, the release function will be called with
dev_data set to NULL.  Check it before using it to avoid a NULL pointer
dereference.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/pci_stub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 258b7c3256499..47c6df53cabfb 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -104,7 +104,8 @@ static void pcistub_device_release(struct kref *kref)
 	 * is called from "unbind" which takes a device_lock mutex.
 	 */
 	__pci_reset_function_locked(dev);
-	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
+	if (dev_data &&
+	    pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
 		dev_info(&dev->dev, "Could not reload PCI state\n");
 	else
 		pci_restore_state(dev);
-- 
2.20.1



