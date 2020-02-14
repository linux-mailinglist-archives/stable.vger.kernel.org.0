Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D0C15F006
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388834AbgBNRwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:52:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388300AbgBNP6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD1712067D;
        Fri, 14 Feb 2020 15:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695919;
        bh=h4NPam10N3eignnDowrf5YwosObCNIFmYck3owIaMUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6F4WA7jI0O6GA7aJ+/SXJ7jaPE7bPnYBtaGnqJJhw91YtpTU8fRfnNyVBkdM/fQU
         Lkx6cVxx+ZeLKJfgjl/gqEoLKfAVFY8dR44doZIYEqdnwmt01D30adcO+MaFDmbYxk
         5+fLkQX3ss6qh6Uj1HaFYBBbReTnpB/CVBZgOy4s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongdong Liu <liudongdong3@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 457/542] PCI/AER: Initialize aer_fifo
Date:   Fri, 14 Feb 2020 10:47:29 -0500
Message-Id: <20200214154854.6746-457-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongdong Liu <liudongdong3@huawei.com>

[ Upstream commit d95f20c4f07020ebc605f3b46af4b6db9eb5fc99 ]

Previously we did not call INIT_KFIFO() for aer_fifo.  This leads to
kfifo_put() sometimes returning 0 (queue full) when in fact it is not.

It is easy to reproduce the problem by using aer-inject:

  $ aer-inject -s :82:00.0 multiple-corr-nonfatal

The content of the multiple-corr-nonfatal file is as below:

  AER
  COR RCVR
  HL 0 1 2 3
  AER
  UNCOR POISON_TLP
  HL 4 5 6 7

Fixes: 27c1ce8bbed7 ("PCI/AER: Use kfifo for tracking events instead of reimplementing it")
Link: https://lore.kernel.org/r/1579767991-103898-1-git-send-email-liudongdong3@huawei.com
Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 1ca86f2e01665..4a818b07a1afb 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1445,6 +1445,7 @@ static int aer_probe(struct pcie_device *dev)
 		return -ENOMEM;
 
 	rpc->rpd = port;
+	INIT_KFIFO(rpc->aer_fifo);
 	set_service_data(dev, rpc);
 
 	status = devm_request_threaded_irq(device, dev->irq, aer_irq, aer_isr,
-- 
2.20.1

