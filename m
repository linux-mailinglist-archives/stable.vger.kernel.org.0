Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0DF59E23C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354262AbiHWKY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354506AbiHWKVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A86EE33;
        Tue, 23 Aug 2022 02:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3F1CB81C54;
        Tue, 23 Aug 2022 09:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0B3C43470;
        Tue, 23 Aug 2022 09:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245373;
        bh=8usOAsQE0nY2RX9D88449YqHhr60C4dx7CTc1aw9+RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUSTGLVvMcZDoZIy1DMrQc8QTyYX0buYsqMqPlBjqZRr3Ok+wM8oIn0aM+re/mQgb
         UKgpWccAv6njA9ejuv434LmH85Nx/EPDxjrPC7I6hVh8ZfqaeNeTkIzGy4/igerZ5J
         pIPumfrrIZkRanP1XMjKUJtaT83lJezt8uu7DeYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/287] soc: fsl: guts: machine variable might be unset
Date:   Tue, 23 Aug 2022 10:23:47 +0200
Message-Id: <20220823080102.193571502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit ab3f045774f704c4e7b6a878102f4e9d4ae7bc74 ]

If both the model and the compatible properties are missing, then
machine will not be set. Initialize it with NULL.

Fixes: 34c1c21e94ac ("soc: fsl: fix section mismatch build warnings")
Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/guts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/guts.c b/drivers/soc/fsl/guts.c
index 302e0c8d69d9..6693c32e7447 100644
--- a/drivers/soc/fsl/guts.c
+++ b/drivers/soc/fsl/guts.c
@@ -136,7 +136,7 @@ static int fsl_guts_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	const struct fsl_soc_die_attr *soc_die;
-	const char *machine;
+	const char *machine = NULL;
 	u32 svr;
 
 	/* Initialize guts */
-- 
2.35.1



