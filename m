Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89645383834
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhEQPup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245133AbhEQPrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A54C61955;
        Mon, 17 May 2021 14:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262685;
        bh=tACtzJn1iPfTDrNLHptdgMfimPbPiD8fZaQVHI01zvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdOCNFKOkqD/BclnLiM/WHP8obsOKs/naiqIGIr2YqUEbGwUforZ+nEK+JqV2hruL
         EOibodUVu0mOMQuYT8THfinCCJ5By8FytFhV9gw8sZpR9T431zVVL7ALCM/bsGdrn4
         U9309YipYG+jRqC6ilMN/+9nEUHdQxSrV6M7vnJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Wolfgang=20M=C3=BCller?= <wolf@oriole.systems>,
        Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/289] Revert "iommu/vt-d: Remove WO permissions on second-level paging entries"
Date:   Mon, 17 May 2021 16:03:06 +0200
Message-Id: <20210517140313.931565813@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c848416cc05afc1589edba04fe00b85c2f797ee3 which is
eea53c5816889ee8b64544fa2e9311a81184ff9c upstream.

Another iommu patch was backported incorrectly, causing problems, so
drop this as well for the moment.

Reported-by: Wolfgang Müller <wolf@oriole.systems>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2362,9 +2362,8 @@ static int __domain_mapping(struct dmar_
 		return -EINVAL;
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
-	attr |= DMA_FL_PTE_PRESENT;
 	if (domain_use_first_level(domain)) {
-		attr |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
+		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD | DMA_FL_PTE_US;
 
 		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
 			attr |= DMA_FL_PTE_ACCESS;


