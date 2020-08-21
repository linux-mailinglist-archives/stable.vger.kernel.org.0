Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF224DBF8
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgHUQus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgHUQUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C2222E00;
        Fri, 21 Aug 2020 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026749;
        bh=tE9xsYHjcyP1RgE3aKIgru7GwEiC8ipKwroxXBMxFY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxuswvCo0tT/K6+9tJEDvMBVZsgaAiKw1JZ7uhi2UscvK5iwB3b9DTZw9CHxnb0Fu
         pgDyZ6J8U+MlnXcfbTmtKOPj/AmKexB86C0hZTtek+OX81LRU1lQRTesKmSWRjbSK7
         DN58wIkp3hT6hBDt2cb0QoFip7oWtZrDG+oAdkpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Prakash Gupta <guptap@codeaurora.org>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 09/30] iommu/iova: Don't BUG on invalid PFNs
Date:   Fri, 21 Aug 2020 12:18:36 -0400
Message-Id: <20200821161857.348955-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161857.348955-1-sashal@kernel.org>
References: <20200821161857.348955-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit d3e3d2be688b4b5864538de61e750721a311e4fc ]

Unlike the other instances which represent a complete loss of
consistency within the rcache mechanism itself, or a fundamental
and obvious misconfiguration by an IOMMU driver, the BUG_ON() in
iova_magazine_free_pfns() can be provoked at more or less any time
in a "spooky action-at-a-distance" manner by any old device driver
passing nonsense to dma_unmap_*() which then propagates through to
queue_iova().

Not only is this well outside the IOVA layer's control, it's also
nowhere near fatal enough to justify panicking anyway - all that
really achieves is to make debugging the offending driver more
difficult. Let's simply WARN and otherwise ignore bogus PFNs.

Reported-by: Prakash Gupta <guptap@codeaurora.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Prakash Gupta <guptap@codeaurora.org>
Link: https://lore.kernel.org/r/acbd2d092b42738a03a21b417ce64e27f8c91c86.1591103298.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iova.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 4edf65dbbcab5..2c97d2552c5bd 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -845,7 +845,9 @@ iova_magazine_free_pfns(struct iova_magazine *mag, struct iova_domain *iovad)
 	for (i = 0 ; i < mag->size; ++i) {
 		struct iova *iova = private_find_iova(iovad, mag->pfns[i]);
 
-		BUG_ON(!iova);
+		if (WARN_ON(!iova))
+			continue;
+
 		private_free_iova(iovad, iova);
 	}
 
-- 
2.25.1

