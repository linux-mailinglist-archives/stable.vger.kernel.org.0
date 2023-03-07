Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F115F6AEB46
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjCGRmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjCGRmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:42:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B40220685
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:38:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F6B61516
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED90C433D2;
        Tue,  7 Mar 2023 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210678;
        bh=P4tDWW0Z0TMN3K+XqbQ72yqJtZe9x/jttgJIqnVgMI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOdIE6RTcDn+j8QGkwWjqfZvwFJmxRD0ZymUJ69TC8b/TPTro1ItPpXbgNmsTQVRo
         it9+HFF3k2tlKxBd7b/Hkm3iLJn46SOTZrVq04h2qKsI7bPUqmKwQP1vZV0tSyWVQT
         J3rN2ux24+WOex0PF+JKIjw/3Mn3/7aoJCGx4Rtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0618/1001] ARM: OMAP2+: omap4-common: Fix refcount leak bug
Date:   Tue,  7 Mar 2023 17:56:30 +0100
Message-Id: <20230307170048.370399092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 7c32919a378782c95c72bc028b5c30dfe8c11f82 ]

In omap4_sram_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220628112939.160737-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap4-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 6d1eb4eefefe5..d9ed2a5dcd5ef 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -140,6 +140,7 @@ static int __init omap4_sram_init(void)
 			__func__);
 	else
 		sram_sync = (void __iomem *)gen_pool_alloc(sram_pool, PAGE_SIZE);
+	of_node_put(np);
 
 	return 0;
 }
-- 
2.39.2



