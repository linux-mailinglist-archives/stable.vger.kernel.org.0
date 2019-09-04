Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B721BA89E3
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbfIDP5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbfIDP5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:57:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DFD02339D;
        Wed,  4 Sep 2019 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612671;
        bh=wGbDoTXpUGNvLUMPRNHZqIwC7xoPQwk3FoWRPShF1UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raBn+YaWKW2mGTZrkWRCi7PI9aTf09piTf30zu3wNfLASrdYQH5ipi08PylBdLgpA
         GhjdVZ4y1bbVpNc7mscGbJJnjuTvsCJdtlkQwXjP8gKipJTueL1gp4etFNi3YBgYlw
         N/Y8r9Q0NusAWHMazWdEDmkJk9J4T7hERQ+OROp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Keerthy <j-keerthy@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 06/94] bus: ti-sysc: Fix using configured sysc mask value
Date:   Wed,  4 Sep 2019 11:56:11 -0400
Message-Id: <20190904155739.2816-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e212abd452a4af3174fcd469d46656f83e135a19 ]

We have cases where there are no softreset bits like with am335x lcdc.
In that case ti,sysc-mask = <0> needs to be handled properly.

Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index f5176a5d38cd9..56a2399f341e8 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1388,10 +1388,7 @@ static int sysc_init_sysc_mask(struct sysc *ddata)
 	if (error)
 		return 0;
 
-	if (val)
-		ddata->cfg.sysc_val = val & ddata->cap->sysc_mask;
-	else
-		ddata->cfg.sysc_val = ddata->cap->sysc_mask;
+	ddata->cfg.sysc_val = val & ddata->cap->sysc_mask;
 
 	return 0;
 }
-- 
2.20.1

