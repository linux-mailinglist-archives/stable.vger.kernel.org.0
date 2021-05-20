Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3439338AB09
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbhETLUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240441AbhETLRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:17:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEA4361951;
        Thu, 20 May 2021 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505384;
        bh=QvUtHm66ypMYgBh9BUX8eRgz4IUf+If+Cao1Z3v2waw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdHLmRmlpg8n717QICkJa02MLg6a5WSTf6N07QLiLRED6hTodgE1DfjJkQnEE1DXD
         Q/B63vVwUQM+9568jDucZ9D4rSJa56Q4K+YbTn8Wwe16H7YOiRVhRQAHAJYsBZW9Ep
         pqAiIBU0i5zKWtvVWbS2WGEPk/vJWtk1rMWTBB8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 076/190] memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
Date:   Thu, 20 May 2021 11:22:20 +0200
Message-Id: <20210520092104.710822420@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index af187c91fc33..f6d06d894538 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -1005,8 +1005,8 @@ EXPORT_SYMBOL(gpmc_cs_request);
 
 void gpmc_cs_free(int cs)
 {
-	struct gpmc_cs_data *gpmc = &gpmc_cs[cs];
-	struct resource *res = &gpmc->mem;
+	struct gpmc_cs_data *gpmc;
+	struct resource *res;
 
 	spin_lock(&gpmc_mem_lock);
 	if (cs >= gpmc_cs_num || cs < 0 || !gpmc_cs_reserved(cs)) {
@@ -1015,6 +1015,9 @@ void gpmc_cs_free(int cs)
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



