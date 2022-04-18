Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E585055A0
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbiDRNY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242584AbiDRNX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:23:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29E53D1DA;
        Mon, 18 Apr 2022 05:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F7E1B80E59;
        Mon, 18 Apr 2022 12:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865F8C385A1;
        Mon, 18 Apr 2022 12:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286362;
        bh=WUAPkXaX+FIRxRV6F+q0jv1YQE4laA/FQC2MJMuYRH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrIxQlEKXSMZ1yjmvZQHUo6a6gY2Hh02SdZrs9qMTvhf0fMMahvPdu4HfgE7fcHUq
         n4KmbigA40EYCOUdCLaYOYYHQW0A5B9t4b4oIRs+P45ps35nhEaUpkMe1ITU9dGEBe
         s+FsPLOXhzZhCwHQpNacUqNuhpxErJC3HPjFJkUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/284] memory: emif: Add check for setup_interrupts
Date:   Mon, 18 Apr 2022 14:11:05 +0200
Message-Id: <20220418121213.074400308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 88c32b8dc88a..ed6c5fcb136f 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1517,7 +1517,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 {
 	struct emif_data	*emif;
 	struct resource		*res;
-	int			irq;
+	int			irq, ret;
 
 	if (pdev->dev.of_node)
 		emif = of_get_memory_device_details(pdev->dev.of_node, &pdev->dev);
@@ -1551,7 +1551,9 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
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



