Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF94246B59
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387925AbgHQPxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387918AbgHQPx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:53:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6582F2177B;
        Mon, 17 Aug 2020 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679601;
        bh=dcddfmLyhXUn3pYXNnA+TfcrOwHJ4l1GD7OgCvFCEDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJEDvwf11mOw6sGlbPqEdl5u1Dov4Z/k2YHGWQBY4281fJnhRyO8m/nx8sevVjDw+
         3zAoOqJ+7nAUmpeHYQh5/uSPMVjokCQy67niQ8M4IvdPoD5640bRfgao1GOrErqtvc
         txtCB0zj9wIQ9Ey/iPQsqM5a1Htz3M0R8rAP/INo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 271/393] PCI: Release IVRS table in AMD ACS quirk
Date:   Mon, 17 Aug 2020 17:15:21 +0200
Message-Id: <20200817143832.765122083@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 090688fa4e448284aaa16136372397d7d10814db ]

The acpi_get_table() should be coupled with acpi_put_table() if the mapped
table is not used at runtime to release the table mapping.

In pci_quirk_amd_sb_acs(), IVRS table is just used for checking AMD IOMMU
is supported, not used at runtime, so put the table after using it.

Fixes: 15b100dfd1c9 ("PCI: Claim ACS support for AMD southbridge devices")
Link: https://lore.kernel.org/r/1595411068-15440-1-git-send-email-guohanjun@huawei.com
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index cd522dd3dd585..5622603d96d4e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4422,6 +4422,8 @@ static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
+	acpi_put_table(header);
+
 	/* Filter out flags not applicable to multifunction */
 	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
 
-- 
2.25.1



