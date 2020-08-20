Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9D24B7C0
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgHTKNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbgHTKNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:13:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC8020724;
        Thu, 20 Aug 2020 10:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918389;
        bh=j7dy0bSZdJMy0fQ8xfWCUsGcJ0bQlI1YyTEiGg3ult0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d42NyCBxsgZjexirkAop6GJeTgyrWzaAeLGe1fxEPcCc18lz9iMtoQkcnjcOPXfLF
         jtLcMT9rC6P3C5hCvATkp9giLUpeVjdovzGWj74RzYoz/8hauz9CCEp8jBwSzuoRLp
         12gEuV68RxJps09YV3S+CZtsLoI2F7v7FaIld5TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/228] PCI: Release IVRS table in AMD ACS quirk
Date:   Thu, 20 Aug 2020 11:21:37 +0200
Message-Id: <20200820091613.689102252@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
index 243b16ce0c8eb..da790f26d2950 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4307,6 +4307,8 @@ static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
+	acpi_put_table(header);
+
 	/* Filter out flags not applicable to multifunction */
 	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
 
-- 
2.25.1



