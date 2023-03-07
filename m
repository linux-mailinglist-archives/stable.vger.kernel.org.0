Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C339B6AEF0D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjCGSTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjCGSTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131BE9FBFC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CADCEB8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4B8C433D2;
        Tue,  7 Mar 2023 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212823;
        bh=hEFn9n/9+hp/VLZHOweCo97ICRUH9F4WDcfe7yXqt2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiVp7YLpbbluWlLRR8JA2aef4V2jn4ZfiSgeVSRnvvkPHIuvaJQoDjvaNdrwS7W6p
         sWpt5WF0CLF5z99oz1JNIzl282HSvV4PipwbK0SlwsASGeull56YhdacwiCUDhR7e/
         KrfoFHz1RxR4dszOkcl8SWXaOdTEdjuk4lpagVX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/885] pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain
Date:   Tue,  7 Mar 2023 17:53:33 +0100
Message-Id: <20230307170014.134530398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit dcef18c8ac40aa85bb339f64c1dd31dd458b06fb ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: d86f4d71e42a ("pinctrl: stm32: check irq controller availability at probe")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20230102082503.3944927-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index e485506ea599c..e198233c10bad 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1380,6 +1380,7 @@ static struct irq_domain *stm32_pctrl_get_irq_domain(struct platform_device *pde
 		return ERR_PTR(-ENXIO);
 
 	domain = irq_find_host(parent);
+	of_node_put(parent);
 	if (!domain)
 		/* domain not registered yet */
 		return ERR_PTR(-EPROBE_DEFER);
-- 
2.39.2



