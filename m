Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0415F23C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbgBNSII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:08:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbgBNPyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751A72467E;
        Fri, 14 Feb 2020 15:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695663;
        bh=DiMCdG6riLHSRN4nxkcS6mNDd2S8rOcMOtsYxDu6lYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFYClWzI/35HO8t33Jz5Ms0wbpWwdDfHpnhxDP/CMapzj+1IuvvSfIaYVLgu4KxIn
         gTrT01BDInWwrSwY3sa8raeEBenUOsFQc2ZGGV7U9mmFbydMDTyhSv8f1yjuYU8X90
         OTHZVBK9EbHJX6rEiSZy1yRBX9JFTYonYa7VEC30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 253/542] PCI/ATS: Restore EXPORT_SYMBOL_GPL() for pci_{enable,disable}_ats()
Date:   Fri, 14 Feb 2020 10:44:05 -0500
Message-Id: <20200214154854.6746-253-sashal@kernel.org>
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

From: Greg Kroah-Hartman <gregkh@google.com>

[ Upstream commit bb950bca5d522119f8b9ce3f6cbac4841c6d6517 ]

Commit d355bb209783 ("PCI/ATS: Remove unnecessary EXPORT_SYMBOL_GPL()")
unexported a bunch of symbols from the PCI core since the only external
users were non-modular IOMMU drivers. Although most of those symbols
can remain private for now, 'pci_{enable,disable_ats()' is required for
the ARM SMMUv3 driver to build as a module, otherwise we get a build
failure as follows:

  | ERROR: "pci_enable_ats" [drivers/iommu/arm-smmu-v3.ko] undefined!
  | ERROR: "pci_disable_ats" [drivers/iommu/arm-smmu-v3.ko] undefined!

Re-export these two functions so that the ARM SMMUv3 driver can be build
as a module.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@google.com>
[will: rewrote commit message]
Signed-off-by: Will Deacon <will@kernel.org>
Tested-by: John Garry <john.garry@huawei.com> # smmu v3
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/ats.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index b6f064c885c37..3ef0bb281e7cc 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -69,6 +69,7 @@ int pci_enable_ats(struct pci_dev *dev, int ps)
 	dev->ats_enabled = 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pci_enable_ats);
 
 /**
  * pci_disable_ats - disable the ATS capability
@@ -87,6 +88,7 @@ void pci_disable_ats(struct pci_dev *dev)
 
 	dev->ats_enabled = 0;
 }
+EXPORT_SYMBOL_GPL(pci_disable_ats);
 
 void pci_restore_ats_state(struct pci_dev *dev)
 {
-- 
2.20.1

