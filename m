Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76815B6F39
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiIMOKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiIMOJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:09:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0C357E33;
        Tue, 13 Sep 2022 07:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD25C6149A;
        Tue, 13 Sep 2022 14:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BEFC433C1;
        Tue, 13 Sep 2022 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078143;
        bh=150roaC0CNIdd5b+cfmwKH6lTavcFXqnMha7Lc8lO5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNV6y5rkjCyM1Bs5r0PBBZ2pNnZaBbGngwF/R02m/B1Uu8qNkYkPI5H3bQMN66xIw
         J56KnWJUFEdZCcYpdcqmGJg40V6bbbCepWm+Esxg2IqTnhrYG2FDfZ9X0klWJkj6E2
         16fIOxC3bxnptS1KwkoafPfkOn9+o0ojIwTlGfUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 029/192] fbdev: omapfb: Fix tests for platform_get_irq() failure
Date:   Tue, 13 Sep 2022 16:02:15 +0200
Message-Id: <20220913140411.367155335@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



