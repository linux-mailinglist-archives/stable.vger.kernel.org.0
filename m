Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E78F594629
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351509AbiHOWs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351557AbiHOWpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:45:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7F13420E;
        Mon, 15 Aug 2022 12:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A489B80EAB;
        Mon, 15 Aug 2022 19:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46043C433C1;
        Mon, 15 Aug 2022 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593159;
        bh=cvYEl2v7R6jrqGqPloGDNravZIBuaPQgB2qMj5zfhmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMeLf7SFd5y3m5GzKcEr0xO8vvZk0yvPoO+H26m4hXsLLlRjIHthYn6bEUNNAprHF
         4ar2LZI81RSeLmqcmbnI0kHAu334JT27Dp+MRbgalC5weIgUcSWN0QUzYyHCayccEN
         Td+EyXvNDpA+3Qhj42WI15gd99zZzAyS0e4g1mK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0223/1157] soc: fsl: guts: machine variable might be unset
Date:   Mon, 15 Aug 2022 19:52:59 +0200
Message-Id: <20220815180448.510675220@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 5ed2fc1c53a0..be18d46c7b0f 100644
--- a/drivers/soc/fsl/guts.c
+++ b/drivers/soc/fsl/guts.c
@@ -140,7 +140,7 @@ static int fsl_guts_probe(struct platform_device *pdev)
 	struct device_node *root, *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
 	const struct fsl_soc_die_attr *soc_die;
-	const char *machine;
+	const char *machine = NULL;
 	u32 svr;
 
 	/* Initialize guts */
-- 
2.35.1



