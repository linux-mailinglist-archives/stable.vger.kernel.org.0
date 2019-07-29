Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57BB0795FF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbfG2Trk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390361AbfG2Tri (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3B12054F;
        Mon, 29 Jul 2019 19:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429658;
        bh=g8YcqszYMpLYIWE3wLbop+l6pI4EBd9uFiiQXkPq9l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRmTX7JSvcxyL6JIukt+ffWTMQ9rYdlgt91j69k9g9mRdgilBtAau3WiG1fHX35H9
         R/k5r8LmLAJOVpgDeFiFOL6kyODjEutt1gyDeHTJtrECH9WckZnPp57qncT/c+usy2
         NBOgtQpiCAo6EgriQ0aVwj9uhUxkEBiF9AFOf29c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Mikhak <alan.mikhak@sifive.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 053/215] PCI: endpoint: Allocate enough space for fixed size BAR
Date:   Mon, 29 Jul 2019 21:20:49 +0200
Message-Id: <20190729190749.712274386@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f16fb16ed16c7f561e9c41c9ae4107c7f6aa553c ]

PCI endpoint test function code should honor the .bar_fixed_size parameter
from underlying endpoint controller drivers or results may be unexpected.

In pci_epf_test_alloc_space(), check if BAR being used for test
register space is a fixed size BAR. If so, allocate the required fixed
size.

Signed-off-by: Alan Mikhak <alan.mikhak@sifive.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 27806987e93b..7d41e6684b87 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -434,10 +434,16 @@ static int pci_epf_test_alloc_space(struct pci_epf *epf)
 	int bar;
 	enum pci_barno test_reg_bar = epf_test->test_reg_bar;
 	const struct pci_epc_features *epc_features;
+	size_t test_reg_size;
 
 	epc_features = epf_test->epc_features;
 
-	base = pci_epf_alloc_space(epf, sizeof(struct pci_epf_test_reg),
+	if (epc_features->bar_fixed_size[test_reg_bar])
+		test_reg_size = bar_size[test_reg_bar];
+	else
+		test_reg_size = sizeof(struct pci_epf_test_reg);
+
+	base = pci_epf_alloc_space(epf, test_reg_size,
 				   test_reg_bar, epc_features->align);
 	if (!base) {
 		dev_err(dev, "Failed to allocated register space\n");
-- 
2.20.1



