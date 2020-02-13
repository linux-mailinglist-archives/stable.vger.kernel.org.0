Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55D715C81B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgBMQUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:20:04 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:55850 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727675AbgBMQUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 11:20:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1581610802; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=zvvISmkod8AHsh7UjrYeGbpLfDZzM5JquD/5OioWC1M=;
        b=yamZkqpnf2uFWWjK9a2OjcPgxGfvfIHED5144hxBDQyFcNZaHmlXRCmsdAmuDdckD6YQtr
        jVyLjweZPAEZAeA3hTWvrjZlK3W6Jwd1bT/IF6CojgsRORZLY9cfZdcBA1a5hujZoS+LTQ
        2drNgAZuRxMeZY18FKRFydN9JfzaI8s=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc:     od@zcrc.me, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2 1/2] clk: ingenic/jz4770: Exit with error if CGU init failed
Date:   Thu, 13 Feb 2020 13:19:51 -0300
Message-Id: <20200213161952.37460-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Exit jz4770_cgu_init() if the 'cgu' pointer we get is NULL, since the
pointer is passed as argument to functions later on.

Fixes: 7a01c19007ad ("clk: Add Ingenic jz4770 CGU driver")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---

Notes:
    v2: Added Fixes: tag

 drivers/clk/ingenic/jz4770-cgu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ingenic/jz4770-cgu.c b/drivers/clk/ingenic/jz4770-cgu.c
index 956dd653a43d..c051ecba5cf8 100644
--- a/drivers/clk/ingenic/jz4770-cgu.c
+++ b/drivers/clk/ingenic/jz4770-cgu.c
@@ -432,8 +432,10 @@ static void __init jz4770_cgu_init(struct device_node *np)
 
 	cgu = ingenic_cgu_new(jz4770_cgu_clocks,
 			      ARRAY_SIZE(jz4770_cgu_clocks), np);
-	if (!cgu)
+	if (!cgu) {
 		pr_err("%s: failed to initialise CGU\n", __func__);
+		return;
+	}
 
 	retval = ingenic_cgu_register_clocks(cgu);
 	if (retval)
-- 
2.25.0

