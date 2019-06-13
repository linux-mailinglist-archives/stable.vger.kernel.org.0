Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75975441E5
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbfFMQRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731134AbfFMIku (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74B862147A;
        Thu, 13 Jun 2019 08:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415250;
        bh=mbqrXAitbexzm8M6vlarDFvT00EESUXBIBpAk6Pf+Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUIjfLvpp5fmLZIHz9oIuijgastmADWPOTH+3pi2vPAyiKbiIXx7b+s2y9GX9RTNO
         PtzK/PAwxQMkg5PAphvf3r64FvaIpLhxbfGPB7o7wN1Aqb5/2l86rPqmci4+QyOTD7
         on8CJhiyiVdJAC6jhSltoX7rQL2AHpYjr4Vb97ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/118] misc: pci_endpoint_test: Fix test_reg_bar to be updated in pci_endpoint_test
Date:   Thu, 13 Jun 2019 10:33:15 +0200
Message-Id: <20190613075647.084348894@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8f220664570e755946db1282f48e07f26e1f2cb4 ]

commit 834b90519925 ("misc: pci_endpoint_test: Add support for
PCI_ENDPOINT_TEST regs to be mapped to any BAR") while adding
test_reg_bar in order to map PCI_ENDPOINT_TEST regs to be mapped to any
BAR failed to update test_reg_bar in pci_endpoint_test, resulting in
test_reg_bar having invalid value when used outside probe.

Fix it.

Fixes: 834b90519925 ("misc: pci_endpoint_test: Add support for PCI_ENDPOINT_TEST regs to be mapped to any BAR")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 896e2df9400f..fd33a3b9c66f 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -662,6 +662,7 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 	data = (struct pci_endpoint_test_data *)ent->driver_data;
 	if (data) {
 		test_reg_bar = data->test_reg_bar;
+		test->test_reg_bar = test_reg_bar;
 		test->alignment = data->alignment;
 		irq_type = data->irq_type;
 	}
-- 
2.20.1



