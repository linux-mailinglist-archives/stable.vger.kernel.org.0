Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD81A5A40
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgDKXGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgDKXGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AF2214D8;
        Sat, 11 Apr 2020 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646397;
        bh=OpFbVyvYnIHYbXaql1M7ib78tJ4gNMyNDUmLjzivcGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWVlA58lktUHHnOy583PmAaQnEb/Ed7OHvfRQCSpdu76E0f2Kb4FodWiLUoG6UJRx
         oOPydRZmUa6gpjDA7eAPGqo1OJzeRkuFULmhoRLLk5rP2s/oNjPeZ1c8YlIYm2154V
         K7w0BKpQKIbp/R8FF+PRXOepvLg7qNnVj+IN83Uc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 135/149] PCI: hv: Add missing kfree(hbus) in hv_pci_probe()'s error handling path
Date:   Sat, 11 Apr 2020 19:03:32 -0400
Message-Id: <20200411230347.22371-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 42c3d41832ef4fcf60aaa6f748de01ad99572adf ]

Now that we use kzalloc() to allocate the hbus buffer, we must call
kfree() in the error path as well to prevent memory leakage.

Fixes: 877b911a5ba0 ("PCI: hv: Avoid a kmemleak false positive caused by the hbus buffer")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 9977abff92fc5..6b3cee4324047 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3058,7 +3058,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 free_dom:
 	hv_put_dom_num(hbus->sysdata.domain);
 free_bus:
-	free_page((unsigned long)hbus);
+	kfree(hbus);
 	return ret;
 }
 
-- 
2.20.1

