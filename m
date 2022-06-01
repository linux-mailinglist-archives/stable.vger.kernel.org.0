Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B988253A89B
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354511AbiFAOLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354722AbiFAOJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C79251;
        Wed,  1 Jun 2022 07:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68892B81AE7;
        Wed,  1 Jun 2022 14:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64ADC3411E;
        Wed,  1 Jun 2022 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092039;
        bh=rCm0BVpzsO/CK/q+0+njTSj5LZslu2hznfOgIzLZnVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSaxGGg8sJnhT8FQ3jF2mnt9MTZEH3xhkzBwofugy8LPm4DuaeIyJfru58IPH0GiX
         Umhkt1f5fq9T5eyTcfqonkUh4778lf8UX2NsRO+OlnuxTjXDopOZH1/7y9MMw3CEkG
         0jU9YLBpXvR0BqLcJYFH+OvraBUPVpAuhTuRitu/Tv1lmNjbLu76IBne+Spj/NkxHL
         5BT/vE2yCCIn5pdY7mbVcMcrPtsHQ11pnYHy/hb3RqnY7Epq4OsKfFQ4mgDMmC3jy4
         ODX4gLGUFx+Mxs2GueD8/rxc1iGF8h6r2oznLcx0eR/zsfsrR72FM/j9swJYN5XRnJ
         Ecy2YANXDBODA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        liviu.dudau@arm.com, sudeep.holla@arm.com,
        lorenzo.pieralisi@arm.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 06/14] ARM: versatile: Add missing of_node_put in dcscb_init
Date:   Wed,  1 Jun 2022 10:00:19 -0400
Message-Id: <20220601140027.2005280-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140027.2005280-1-sashal@kernel.org>
References: <20220601140027.2005280-1-sashal@kernel.org>
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

