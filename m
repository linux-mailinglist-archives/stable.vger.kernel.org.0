Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575E54EF004
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347182AbiDAOa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347078AbiDAO3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805532895AC;
        Fri,  1 Apr 2022 07:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D106B61C3F;
        Fri,  1 Apr 2022 14:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618FBC2BBE4;
        Fri,  1 Apr 2022 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823235;
        bh=XDdrt3Zdkqf91+hsmo+atvf9Fl2UncK5Pbj1CzGlJm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfWMpevkqUxFGU1DHgaE2lF9GTSml12ZoHoonIGLKVlKh+2tgbgkinsA6l2G6nETP
         c3dbxiCGaY1MCIPUKUOHdbFkmxZzJFWt7HlHbs4lfmNmcZsmdAyrVoewh+rg0kbDxY
         oUCR1+7GtKR4cN58YsuXJVioo5/SrwQqb1Uexhq+oGPz8OmdNzBMCWNzytW3lBqyut
         gS2K9V079sRbsptaz42urIFtFeHWBkkgDn3vuSsi8HrcVqmyffk6DweCkr2wwFfIth
         j+wTQ6E84WBqKty/y32t8ywCkZWxp5m+b9Uad0xhPi0bMQi89Ny3BID9mcPqzJA771
         4osOANCmOi9dQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sachin Sant <sachinp@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, groug@kaod.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.17 027/149] powerpc/xive: Export XIVE IPI information for online-only processors.
Date:   Fri,  1 Apr 2022 10:23:34 -0400
Message-Id: <20220401142536.1948161-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Sachin Sant <sachinp@linux.ibm.com>

[ Upstream commit 279d1a72c0f8021520f68ddb0a1346ff9ba1ea8c ]

Cédric pointed out that XIVE IPI information exported via sysfs
(debug/powerpc/xive) display empty lines for processors which are
not online.

Switch to using for_each_online_cpu() so that information is
displayed for online-only processors.

Reported-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Sachin Sant <sachinp@linux.ibm.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/164146703333.19039.10920919226094771665.sendpatchset@MacBook-Pro.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 1ca5564bda9d..32863b4daf72 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1791,7 +1791,7 @@ static int xive_ipi_debug_show(struct seq_file *m, void *private)
 	if (xive_ops->debug_show)
 		xive_ops->debug_show(m, private);
 
-	for_each_possible_cpu(cpu)
+	for_each_online_cpu(cpu)
 		xive_debug_show_ipi(m, cpu);
 	return 0;
 }
-- 
2.34.1

