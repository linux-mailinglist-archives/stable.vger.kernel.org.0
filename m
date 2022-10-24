Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB660A8FE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiJXNNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbiJXNM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:12:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E94C11C26;
        Mon, 24 Oct 2022 05:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94942612A1;
        Mon, 24 Oct 2022 12:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07AAC433C1;
        Mon, 24 Oct 2022 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614203;
        bh=/trz6K8V8Y183basi795y1i/HvhwO6Kujiip5x0dDp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXu7WwR63TmnFiuBmoiq+aMGU3TdHio9w4mBP7Cu67BHpakZfTjPDodhNtGtS1NLS
         a7nlG16JAqz4Bl1MjrunbmD8XOBi/0LIwoHrLyLLaKb+ujRvs4HFUzgTixiUvhCv4u
         RS9XPpXoABwgvb9hqXSS4AMIXhkuxHwH5V3dCCSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/390] memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()
Date:   Mon, 24 Oct 2022 13:29:28 +0200
Message-Id: <20221024113029.994815067@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 61b3c876c1cbdb1efd1f52a1f348580e6e14efb6 ]

The break of for_each_available_child_of_node() needs a
corresponding of_node_put() when the reference 'child' is not
used anymore. Here we do not need to call of_node_put() in
fail path as '!match' means no break.

While the of_platform_device_create() will created a new
reference by 'child' but it has considered the refcounting.

Fixes: fee10bd22678 ("memory: pl353: Add driver for arm pl353 static memory controller")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220716031324.447680-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/pl353-smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/pl353-smc.c b/drivers/memory/pl353-smc.c
index b0b251bb207f..1a6964f1ba6a 100644
--- a/drivers/memory/pl353-smc.c
+++ b/drivers/memory/pl353-smc.c
@@ -416,6 +416,7 @@ static int pl353_smc_probe(struct amba_device *adev, const struct amba_id *id)
 	if (init)
 		init(adev, child);
 	of_platform_device_create(child, NULL, &adev->dev);
+	of_node_put(child);
 
 	return 0;
 
-- 
2.35.1



