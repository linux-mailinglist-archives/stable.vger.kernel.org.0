Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973ED4F3E53
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380794AbiDEMN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357908AbiDEK1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC3752E44;
        Tue,  5 Apr 2022 03:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAACDB81C8A;
        Tue,  5 Apr 2022 10:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F8FC385A1;
        Tue,  5 Apr 2022 10:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153471;
        bh=J/oTdw4gTIbU4qw4E5l1JZWzyRyCSgOzA8DVNvpbBxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlakdZlP5yDryeXz4y+uuRblk2BGdLeKhN3v6G0xSWm99osviRwL+tpc2hZaD63xb
         Dj5xr/xBkfLYpKYvvmwi0e5i7DDz4ZhG6nUtpwImpOYLFm5EaXxMI3cEgaNSKx0wUx
         kpcFW9ekXY8c2XcG98YZcZ5v2h9R2wAw7O44amT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/599] memory: emif: Add check for setup_interrupts
Date:   Tue,  5 Apr 2022 09:28:46 +0200
Message-Id: <20220405070305.745224529@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit fd7bd80b46373887b390852f490f21b07e209498 ]

As the potential failure of the devm_request_threaded_irq(),
it should be better to check the return value of the
setup_interrupts() and return error if fails.

Fixes: 68b4aee35d1f ("memory: emif: add interrupt and temperature handling")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220224025444.3256530-1-jiasheng@iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index ddb1879f07d3..55d4c842fcd9 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1495,7 +1495,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 {
 	struct emif_data	*emif;
 	struct resource		*res;
-	int			irq;
+	int			irq, ret;
 
 	if (pdev->dev.of_node)
 		emif = of_get_memory_device_details(pdev->dev.of_node, &pdev->dev);
@@ -1526,7 +1526,9 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	emif_onetime_settings(emif);
 	emif_debugfs_init(emif);
 	disable_and_clear_all_interrupts(emif);
-	setup_interrupts(emif, irq);
+	ret = setup_interrupts(emif, irq);
+	if (ret)
+		goto error;
 
 	/* One-time actions taken on probing the first device */
 	if (!emif1) {
-- 
2.34.1



