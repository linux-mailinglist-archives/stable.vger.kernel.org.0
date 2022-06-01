Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9E953A869
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354602AbiFAOIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354630AbiFAOH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:07:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2957A339A;
        Wed,  1 Jun 2022 07:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798786149F;
        Wed,  1 Jun 2022 14:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B8EC34119;
        Wed,  1 Jun 2022 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092004;
        bh=rCm0BVpzsO/CK/q+0+njTSj5LZslu2hznfOgIzLZnVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDLs1kEFCozFfQSzDXkm6zmb94RK5GrRN90yOW9/eTFlOMuweSKQs3Ta2I8uZMRDQ
         DzZmU/xYIgo3R8A5k9LL7slUFvZKbymy1yF2fnJsI66gL3W6LeOjBrfvl1KJgpXQX5
         nSJcdfGvzbEURd+9gsaz7bBhh67/7aWg8s+4mZ88fdn3uEPcpdIu/xobkUWIRlVfOC
         gTzA+ivgpm31r4/V015UpI3LPSYm/65ojfpcOlB1/wL41umGJpyGFH0GL8G52I1CFD
         VlvvaXyRyWy0IiN7eAKDvkX3WW58s1M4bZ4mYjbMAWVSdhF3T1c1hqUlCdN2+GLEux
         dAlFW2HiUOm9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        liviu.dudau@arm.com, sudeep.holla@arm.com,
        lorenzo.pieralisi@arm.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 07/15] ARM: versatile: Add missing of_node_put in dcscb_init
Date:   Wed,  1 Jun 2022 09:59:42 -0400
Message-Id: <20220601135951.2005085-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135951.2005085-1-sashal@kernel.org>
References: <20220601135951.2005085-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 23b44f9c649bbef10b45fa33080cd8b4166800ae ]

The device_node pointer is returned by of_find_compatible_node
with refcount incremented. We should use of_node_put() to avoid
the refcount leak.

Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220428230356.69418-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-vexpress/dcscb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-vexpress/dcscb.c b/arch/arm/mach-vexpress/dcscb.c
index ee2a0faafaa1..aaade91f6551 100644
--- a/arch/arm/mach-vexpress/dcscb.c
+++ b/arch/arm/mach-vexpress/dcscb.c
@@ -146,6 +146,7 @@ static int __init dcscb_init(void)
 	if (!node)
 		return -ENODEV;
 	dcscb_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!dcscb_base)
 		return -EADDRNOTAVAIL;
 	cfg = readl_relaxed(dcscb_base + DCS_CFG_R);
-- 
2.35.1

