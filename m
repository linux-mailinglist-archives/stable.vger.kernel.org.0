Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24F540DBF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353656AbiFGSuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354424AbiFGSrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8806403E4;
        Tue,  7 Jun 2022 11:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B602618E1;
        Tue,  7 Jun 2022 18:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FACC3411F;
        Tue,  7 Jun 2022 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624869;
        bh=wHYFN9MuumJK9P6jgiI8aiyR/phLTziKEKbXcop84ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mv7mbl3Ym+RbMiqi3lnHpwcTlfA4TXgX4EZ3H8pi5sX1aQS45ta2AxkhOdBWeOKGn
         LoAMpEduztCgwyfPDBz1DBArC8W6w/HqibTYWKoGxP5hZy24ZepnKjijxv8l2yHYQj
         QOrKIWZs2Zh847+qOgMxg0S+WqImqGeSEVD4mo1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/667] pinctrl: renesas: core: Fix possible null-ptr-deref in sh_pfc_map_resources()
Date:   Tue,  7 Jun 2022 19:01:47 +0200
Message-Id: <20220607164947.976980687@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5376e3d904532e657fd7ca1a9b1ff3d351527b90 ]

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: c7977ec4a336 ("pinctrl: sh-pfc: Convert to platform_get_*()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220429082637.1308182-1-yangyingliang@huawei.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index bc17f3131de5..75fc420b6bdf 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -71,12 +71,11 @@ static int sh_pfc_map_resources(struct sh_pfc *pfc,
 
 	/* Fill them. */
 	for (i = 0; i < num_windows; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		windows->phys = res->start;
-		windows->size = resource_size(res);
-		windows->virt = devm_ioremap_resource(pfc->dev, res);
+		windows->virt = devm_platform_get_and_ioremap_resource(pdev, i, &res);
 		if (IS_ERR(windows->virt))
 			return -ENOMEM;
+		windows->phys = res->start;
+		windows->size = resource_size(res);
 		windows++;
 	}
 	for (i = 0; i < num_irqs; i++)
-- 
2.35.1



