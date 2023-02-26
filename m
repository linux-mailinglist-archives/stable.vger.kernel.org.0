Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECCF6A2D8E
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBZDoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBZDnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:43:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AED1632E;
        Sat, 25 Feb 2023 19:43:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2683CB80B8D;
        Sun, 26 Feb 2023 03:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5FAC433D2;
        Sun, 26 Feb 2023 03:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382979;
        bh=LOy8hIp7Z8iWgeS0WqLr8AmLj+SvkhZkgozIO0aaJbY=;
        h=From:To:Cc:Subject:Date:From;
        b=teQiEpp0SoXb2ets/CRNLG8gstdyhLiEQzV5rjJ6mAlAonaHBlHhmPiW9dvqnGzJh
         +3KliMkVfLcynwWm3QwVQEN7ELr2ImKCZa21xrKN3KOImjbT6U0/nSHkzs1bgFd0NB
         dyJB8BAN2f+ocXJDnamcT64hI6jMT/R1EmVx5BpZFUYG8/bPyeQEciWW6hW4ORUJBE
         WV5xNr3IcDkKn2Ar6AGfa42fYVzeU/ehEybTVh6AjqDm5iO2aFqGdazZFoqfV/2jyc
         ayVqZATouo18qrTDnweXi/2YnyU8V1+XbkCFR3IpcRjw+i+2xcY9/j+cVXx0ZSTj1N
         npqziA1XvarTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/21] ARM: OMAP2+: omap4-common: Fix refcount leak bug
Date:   Sat, 25 Feb 2023 22:42:36 -0500
Message-Id: <20230226034256.771769-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
2.39.0

