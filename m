Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA4CA8AA2
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732592AbfIDQAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732587AbfIDQAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 080C02087E;
        Wed,  4 Sep 2019 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612812;
        bh=G/uRdqFkHn7/5EBZ7Enh1oxM91e/mho9qyCW+FhVgXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4shAZe+lXASoqK6UYBM+OiBlgAnnflVC6q+mIlPNwoI4u1U00WaO4ZBwKlJGhTne
         tQGWvdbGn9PV5N4qG3OsKsWqUnHH0CqiSltdet0orqBxL8QKA2A6xiUlK/N3JZ4/As
         gosMZpr4Qu4niBEq60RyeTOWX49Bkkorb25CNBMg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Keerthy <j-keerthy@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 05/52] bus: ti-sysc: Fix using configured sysc mask value
Date:   Wed,  4 Sep 2019 11:59:17 -0400
Message-Id: <20190904160004.3671-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
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
index e4fe954e63a9b..4ca006e2137f7 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1022,10 +1022,7 @@ static int sysc_init_sysc_mask(struct sysc *ddata)
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

