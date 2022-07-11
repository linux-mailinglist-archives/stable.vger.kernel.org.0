Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67D956FA1D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiGKJNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiGKJMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A962C64E;
        Mon, 11 Jul 2022 02:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2063C61148;
        Mon, 11 Jul 2022 09:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A30C34115;
        Mon, 11 Jul 2022 09:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530569;
        bh=y6X5oj2du+G17bRly/PCr2Z1anJaJ8LV5xkD5Zj3fhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5sJ0Og32y7HHfyHfIFi1gwZ8efYLh5pnxBZzm0j9D338qQ9kD9UZEPyVDoRhQ63F
         P33WyS5FbCIC43FkcQgviogdU+VafhPCudGJ/DERHNIDMC3ihYG7kcSytGJ4ovb+jV
         u3BPd9khRYQM1MpSHZEhBtAb8LkdYJTMPiuFW+Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/31] ARM: meson: Fix refcount leak in meson_smp_prepare_cpus
Date:   Mon, 11 Jul 2022 11:06:55 +0200
Message-Id: <20220711090538.328749213@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 34d2cd3fccced12b958b8848e3eff0ee4296764c ]

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: d850f3e5d296 ("ARM: meson: Add SMP bringup code for Meson8 and Meson8b")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220512021611.47921-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-meson/platsmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-meson/platsmp.c b/arch/arm/mach-meson/platsmp.c
index cad7ee8f0d6b..75e16a2c3c81 100644
--- a/arch/arm/mach-meson/platsmp.c
+++ b/arch/arm/mach-meson/platsmp.c
@@ -81,6 +81,7 @@ static void __init meson_smp_prepare_cpus(const char *scu_compatible,
 	}
 
 	sram_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!sram_base) {
 		pr_err("Couldn't map SRAM registers\n");
 		return;
@@ -101,6 +102,7 @@ static void __init meson_smp_prepare_cpus(const char *scu_compatible,
 	}
 
 	scu_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!scu_base) {
 		pr_err("Couldn't map SCU registers\n");
 		return;
-- 
2.35.1



