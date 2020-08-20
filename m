Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F81524B5D3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgHTK2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbgHTKVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:21:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C782072D;
        Thu, 20 Aug 2020 10:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918901;
        bh=k3wht7a5DX1U9Aa/TvBmtEezKgpqipZxjo4IhICNmKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJqb6LjjFuqRBsDKqooPOtwu/BrCJdp4Tky2hsCa6ApY0mAY7kEo3lM46N6EZ/MFl
         J5Q0jxreLgzipiAV+RRmHFz1vxm/iNafMhnDaeuwzYEmGGOZPY0LMRDgAthKAf7gmo
         yElOFi0KbqjI7ZcBrLyeeqOHxRWNTzYAk7sLkq3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 077/149] agp/intel: Fix a memory leak on module initialisation failure
Date:   Thu, 20 Aug 2020 11:22:34 +0200
Message-Id: <20200820092129.457360989@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit b975abbd382fe442713a4c233549abb90e57c22b ]

In intel_gtt_setup_scratch_page(), pointer "page" is not released if
pci_dma_mapping_error() return an error, leading to a memory leak on
module initialisation failure.  Simply fix this issue by freeing "page"
before return.

Fixes: 0e87d2b06cb46 ("intel-gtt: initialize our own scratch page")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200522083451.7448-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/agp/intel-gtt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 76afc841232cf..3d11f5adb355e 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -303,8 +303,10 @@ static int intel_gtt_setup_scratch_page(void)
 	if (intel_private.needs_dmar) {
 		dma_addr = pci_map_page(intel_private.pcidev, page, 0,
 				    PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(intel_private.pcidev, dma_addr))
+		if (pci_dma_mapping_error(intel_private.pcidev, dma_addr)) {
+			__free_page(page);
 			return -EINVAL;
+		}
 
 		intel_private.scratch_page_dma = dma_addr;
 	} else
-- 
2.25.1



