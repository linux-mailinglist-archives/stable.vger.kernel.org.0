Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001855A69CD
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiH3RXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiH3RWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:22:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33ECF2416;
        Tue, 30 Aug 2022 10:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C3E2B81C35;
        Tue, 30 Aug 2022 17:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB21DC433C1;
        Tue, 30 Aug 2022 17:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880047;
        bh=150roaC0CNIdd5b+cfmwKH6lTavcFXqnMha7Lc8lO5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAna+t3I9XfWr8j0C6GGhKqIUB0y6GhddjSZrgtiqXrFmgBIGT83aJ1YEGsKFu8Rj
         IImmn77OwftNI1kdOKVN9Qxe1ftJE0wbK+qhhS1gAAFQ1/cPdOQTuubuMO7K2ywWtk
         9YtuRNuIchzq1IUg9YNouPpqnqlnb7xzMkSn4j5mQpJqZ/9aUBmkX5I01qtd+P6sst
         RD7Nk/DUhJpNmQ6g0yZ+fedgpEmgplp/ySqgugaQeY5JhYctSOT+9XtnJfD9DJqtGt
         w3H+IlebBDmrtwAOrTGwy5AlxKna8XbBMVjO3pk2unEPukaNMf1P2Iz9565E44rVcV
         Smqx48WusyY0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhe <yuzhe@nfschina.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        tony@atomide.com, b.zolnierkie@samsung.com,
        jiapeng.chong@linux.alibaba.com, guozhengkui@vivo.com,
        gustavoars@kernel.org, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 27/33] fbdev: omapfb: Fix tests for platform_get_irq() failure
Date:   Tue, 30 Aug 2022 13:18:18 -0400
Message-Id: <20220830171825.580603-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Zhe <yuzhe@nfschina.com>

[ Upstream commit acf4c6205e862304681234a6a4375b478af12552 ]

The platform_get_irq() returns negative error codes.  It can't actually
return zero.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap/omapfb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
index 292fcb0a24fc9..6ff237cee7f87 100644
--- a/drivers/video/fbdev/omap/omapfb_main.c
+++ b/drivers/video/fbdev/omap/omapfb_main.c
@@ -1643,14 +1643,14 @@ static int omapfb_do_probe(struct platform_device *pdev,
 		goto cleanup;
 	}
 	fbdev->int_irq = platform_get_irq(pdev, 0);
-	if (!fbdev->int_irq) {
+	if (fbdev->int_irq < 0) {
 		dev_err(&pdev->dev, "unable to get irq\n");
 		r = ENXIO;
 		goto cleanup;
 	}
 
 	fbdev->ext_irq = platform_get_irq(pdev, 1);
-	if (!fbdev->ext_irq) {
+	if (fbdev->ext_irq < 0) {
 		dev_err(&pdev->dev, "unable to get irq\n");
 		r = ENXIO;
 		goto cleanup;
-- 
2.35.1

