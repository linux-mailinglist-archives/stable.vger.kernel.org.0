Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2932437C38D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhELPUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhELPRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23B66195F;
        Wed, 12 May 2021 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832035;
        bh=OutA4LIeEjcDid8OGBeOVhqgU0w91cHH6NxHdsKbaME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqaYnxkegI5PLiO07FZJlYBJuKQRs+Ctkip66o/XG4DSJhxY+nGUivg6EZc+ziVRz
         UIVsll2uy8g7vVVeRd7beaJ2BTx8QlEU6K93C9wDKZlHpBxfJuVU73Zw9zMH30o+j6
         v5XweyPxUxjgclmDZyq9dMnVBEBPUTL2fDurOs+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/530] memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
Date:   Wed, 12 May 2021 16:43:46 +0200
Message-Id: <20210512144823.622329482@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e004c3e67b6459c99285b18366a71af467d869f5 ]

Currently the array gpmc_cs is indexed by cs before it cs is range checked
and the pointer read from this out-of-index read is dereferenced. Fix this
by performing the range check on cs before the read and the following
pointer dereference.

Addresses-Coverity: ("Negative array index read")
Fixes: 9ed7a776eb50 ("ARM: OMAP2+: Fix support for multiple devices on a GPMC chip select")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210223193821.17232-1-colin.king@canonical.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/omap-gpmc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index cfa730cfd145..f80c2ea39ca4 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -1009,8 +1009,8 @@ EXPORT_SYMBOL(gpmc_cs_request);
 
 void gpmc_cs_free(int cs)
 {
-	struct gpmc_cs_data *gpmc = &gpmc_cs[cs];
-	struct resource *res = &gpmc->mem;
+	struct gpmc_cs_data *gpmc;
+	struct resource *res;
 
 	spin_lock(&gpmc_mem_lock);
 	if (cs >= gpmc_cs_num || cs < 0 || !gpmc_cs_reserved(cs)) {
@@ -1018,6 +1018,9 @@ void gpmc_cs_free(int cs)
 		spin_unlock(&gpmc_mem_lock);
 		return;
 	}
+	gpmc = &gpmc_cs[cs];
+	res = &gpmc->mem;
+
 	gpmc_cs_disable_mem(cs);
 	if (res->flags)
 		release_resource(res);
-- 
2.30.2



