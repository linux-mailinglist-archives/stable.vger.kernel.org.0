Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3691D37CBB1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhELQhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241732AbhELQ15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD06F61DFF;
        Wed, 12 May 2021 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834941;
        bh=OutA4LIeEjcDid8OGBeOVhqgU0w91cHH6NxHdsKbaME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoYtIT4erhr24PETEtgU80rcFSlojmxnpdqD+wcFxZA9672zmMgJevyDUHqS9cjpJ
         VCdBGcProU1tlYGJw1taeTdHzcU1HJz01+ZhDt7MnKh2GbaQtQpYNtlooX6/IMVLZy
         6D8IZlrRqWvMdyb11CgjOb9dG96IXcgEVp3iJSk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 144/677] memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]
Date:   Wed, 12 May 2021 16:43:10 +0200
Message-Id: <20210512144842.032725877@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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



