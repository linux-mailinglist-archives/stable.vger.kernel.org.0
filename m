Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C71323D2F
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhBXNFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231638AbhBXM7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:59:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF6464F4D;
        Wed, 24 Feb 2021 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171167;
        bh=o6lMHRaKPixVC1HZQNtIrzH1xp+qIqojVdFUOi8aqIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmatulA8CBSSwEli4T08aSqC6kZG2+mh5YY8sTSz02T3DyCqBQJlp4liooUH0ELJ6
         CpaC3iDD/Obcef1K+RBSZWPn3AmG/evj04LqFZfQTBcyl6GjSf+G/3SwihCixzUYPd
         cqz/25U1sNXagZbPAiggvHRzCDAvHMLRHrobDxTulEdWUKCJFxtkfq6zIAaOY13Nya
         2Uir48v6ISD74Z5kMzT78zIbThjxtT+h7cLJ+MJ/8ic9QqTYGBrWri4gak7JCulrYM
         bQdxnf98YIBPBd6qSCZSOvTsVIljydjeYSoUTXyrQgFIBqxaYb6tdzkLxLqyHdN+Pb
         viS2q8Eos7+tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/56] PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse
Date:   Wed, 24 Feb 2021 07:51:42 -0500
Message-Id: <20210224125212.482485-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 907830b0fc9e374d00f3c83de5e426157b482c01 ]

RX 5600 XT Pulse advertises support for BAR 0 being 256MB, 512MB,
or 1GB, but it also supports 2GB, 4GB, and 8GB. Add a rebar
size quirk so that the BAR 0 is big enough to cover complete VARM.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20210107175017.15893-5-nirmoy.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6427cbd0a5be2..5c93450725108 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3577,7 +3577,14 @@ u32 pci_rebar_get_possible_sizes(struct pci_dev *pdev, int bar)
 		return 0;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CAP, &cap);
-	return (cap & PCI_REBAR_CAP_SIZES) >> 4;
+	cap &= PCI_REBAR_CAP_SIZES;
+
+	/* Sapphire RX 5600 XT Pulse has an invalid cap dword for BAR 0 */
+	if (pdev->vendor == PCI_VENDOR_ID_ATI && pdev->device == 0x731f &&
+	    bar == 0 && cap == 0x7000)
+		cap = 0x3f000;
+
+	return cap >> 4;
 }
 
 /**
-- 
2.27.0

