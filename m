Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62D26087B9
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiJVIFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiJVIEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769892C56A2;
        Sat, 22 Oct 2022 00:52:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB7860B27;
        Sat, 22 Oct 2022 07:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705F5C433C1;
        Sat, 22 Oct 2022 07:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424982;
        bh=Vq582+ZZfZeJ50akCNDAGdJDlR6WOX/d4TZ2XfKNEBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1ojZjYJ+WKoGRnVqkopJHz02L/p5rWgxmMEsDCJEISCgXRdZd7FV+C207mc4pNjD
         XaC3Mcmx83bZzBr4hfJ8EcO9L/WQkbtHdNSoY77P9RMjoFi/UOuXt2nu3Mok+ZnQsn
         For+ErqK6JMEkPChwWaQV+eHV4j2FiMEeO/J3wVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 348/717] memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()
Date:   Sat, 22 Oct 2022 09:23:47 +0200
Message-Id: <20221022072511.097903821@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f84b98278745..d39ee7d06665 100644
--- a/drivers/memory/pl353-smc.c
+++ b/drivers/memory/pl353-smc.c
@@ -122,6 +122,7 @@ static int pl353_smc_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	of_platform_device_create(child, NULL, &adev->dev);
+	of_node_put(child);
 
 	return 0;
 
-- 
2.35.1



