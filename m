Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566E413349F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgAGU6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbgAGU6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A563521744;
        Tue,  7 Jan 2020 20:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430691;
        bh=ZlW7Z4RUDwYLO3sEu7uHLLDVB0up3MAMmSBGy9XWbVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMRU+26E+0pHYPk7PI7fS1P15b9SyMJl64OSLpxgpP36dM1IIMn153GDcJvXZt8w6
         mtfNag0psr74I/+jSlDSiqX0YsE8fHqFIfsEhjlN2oayPc0iPmqKj1Mlw/OeWTK5m7
         J0N59/X+C2U1PURjUnQdEsV6uRNQOuKsw4IqOfsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/191] PCI: Fix missing inline for pci_pr3_present()
Date:   Tue,  7 Jan 2020 21:52:57 +0100
Message-Id: <20200107205336.049541939@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 46b4bff6572b0552b1ee062043621e4b252638d8 ]

The inline prefix was missing in the dummy function pci_pr3_present()
definition.  Fix it.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 52525b7a3cf8 ("PCI: Add a helper to check Power Resource Requirements _PR3 existence")
Link: https://lore.kernel.org/r/201910212111.qHm6OcWx%lkp@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1d15c5d49cdd..be529d311122 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2314,7 +2314,7 @@ bool pci_pr3_present(struct pci_dev *pdev);
 #else
 static inline struct irq_domain *
 pci_host_bridge_acpi_msi_domain(struct pci_bus *bus) { return NULL; }
-static bool pci_pr3_present(struct pci_dev *pdev) { return false; }
+static inline bool pci_pr3_present(struct pci_dev *pdev) { return false; }
 #endif
 
 #ifdef CONFIG_EEH
-- 
2.20.1



