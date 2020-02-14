Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7D15E77C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404810AbgBNQSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404806AbgBNQSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:18:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AAF24703;
        Fri, 14 Feb 2020 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697117;
        bh=+wD6czIUhxuJuyD9X9uh5dT1pP9vh8/2qPEPFFBPEDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czmuyAiU+Dej8ONA63AieFFoP71ypPpVrbr+QcLSIfTs2M98v4wew+euRRNF+Ab0f
         RfwOr8yUBUqV59GBw0URJJTmZv4wnvv2wWnehi9B1ys7CMEaSVlzgqmd30KFoRjdpL
         bAoLfBo5LZ523+YtUB/cVL2S0LCrE0fiDja6E9FU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 064/186] PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
Date:   Fri, 14 Feb 2020 11:15:13 -0500
Message-Id: <20200214161715.18113-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 8c386cc817878588195dde38e919aa6ba9409d58 ]

In the implementation of pci_iov_add_virtfn() the allocated virtfn is
leaked if pci_setup_device() fails. The error handling is not calling
pci_stop_and_remove_bus_device(). Change the goto label to failed2.

Fixes: 156c55325d30 ("PCI: Check for pci_setup_device() failure in pci_iov_add_virtfn()")
Link: https://lore.kernel.org/r/20191125195255.23740-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0fd8e164339c3..0dc646c1bc3db 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -179,6 +179,7 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id, int reset)
 failed2:
 	sysfs_remove_link(&dev->dev.kobj, buf);
 failed1:
+	pci_stop_and_remove_bus_device(virtfn);
 	pci_dev_put(dev);
 	pci_stop_and_remove_bus_device(virtfn);
 failed0:
-- 
2.20.1

