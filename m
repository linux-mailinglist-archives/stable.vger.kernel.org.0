Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0038455D264
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbiF1CaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244741AbiF1C1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A525EBE;
        Mon, 27 Jun 2022 19:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 194C861853;
        Tue, 28 Jun 2022 02:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779FFC341CB;
        Tue, 28 Jun 2022 02:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383149;
        bh=5dbIa1ntt+i2cvKwDMw1an0esFdl/E501OVL+rAfOGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojYaKaCDGMIOHq2vRq24KSPZb9CDo4RE0pnkID8QHnT9oPenWSaem8AbzHEt6hCpD
         +sMFiV3gyNQSs8vCegNH8l1Y1bzdGS6xs2LWB9X7rkg3YTyS13W0TyX9/IMAggTUj7
         CP15MdD4zXeyYIhz2Wk99pvph1QGBjI2hNMvfGjrXZQQIuPCMmW/hpOa7+rUC5uUyO
         PD1QeE9aOQMsbqF5HebXUuh4PMXzP6lU1yss/ZPaSOMEvcgJ+EzoIPJR5MxDdjM8QZ
         BZgdBOyzi+JHTm1gXlFjoXG+FtubH2bLmQtvi6n30dNS7JkOI0rYSTrn4YdutDfVxW
         82lovE1TG1wEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yihao Han <hanyihao@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 12/22] video: fbdev: simplefb: Check before clk_put() not needed
Date:   Mon, 27 Jun 2022 22:25:07 -0400
Message-Id: <20220628022518.596687-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022518.596687-1-sashal@kernel.org>
References: <20220628022518.596687-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yihao Han <hanyihao@vivo.com>

[ Upstream commit 5491424d17bdeb7b7852a59367858251783f8398 ]

clk_put() already checks the clk ptr using !clk and IS_ERR()
so there is no need to check it again before calling it.

Signed-off-by: Yihao Han <hanyihao@vivo.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/simplefb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 9a9d748b07f2..30b004b88e8c 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -233,8 +233,7 @@ static int simplefb_clocks_get(struct simplefb_par *par,
 		if (IS_ERR(clock)) {
 			if (PTR_ERR(clock) == -EPROBE_DEFER) {
 				while (--i >= 0) {
-					if (par->clks[i])
-						clk_put(par->clks[i]);
+					clk_put(par->clks[i]);
 				}
 				kfree(par->clks);
 				return -EPROBE_DEFER;
-- 
2.35.1

