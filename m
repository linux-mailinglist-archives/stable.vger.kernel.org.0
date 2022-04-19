Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1335078AF
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357150AbiDSSZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357508AbiDSSX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20270443D7;
        Tue, 19 Apr 2022 11:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2C2261426;
        Tue, 19 Apr 2022 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D02C385A5;
        Tue, 19 Apr 2022 18:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392188;
        bh=aj2MJe6FxnGwrXKvMahFbCQYAaT+4ocJ3YhgWHEGcDc=;
        h=From:To:Cc:Subject:Date:From;
        b=s1WO8ZZ8hy0M0bI4LP9gCWe6jQrruFytNrqTbEWX0IJ+I5nTNU9iYt4dPFB8rgg31
         4/daPbnftZPDoOvSHMq2MKWlwb9jch3UHHBqHBmfvWP/rK892Fa49OG35KM6YPPlif
         HOAZPHj7UKZHTwefet4y1x8SX0jJCHSXWsQD1rIW5zuh1A9LjMMC9Q/q8M7K5up+86
         6fX4aHCmIi2lKq01NBHrYi108JNahEJjPia1an8nto52GnzCl6FMxXB2mA96GfPQl8
         sL+NnvyEhAISIka1ZVFdPPmKqtfQA3ab3wJrWJlykH3qLpxoVCqrvS+byPPu36Ux5b
         MENZpCA+QUNLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 1/7] ARM: vexpress/spc: Avoid negative array index when !SMP
Date:   Tue, 19 Apr 2022 14:16:19 -0400
Message-Id: <20220419181625.486476-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b3f1dd52c991d79118f35e6d1bf4d7cb09882e38 ]

When building multi_v7_defconfig+CONFIG_SMP=n, -Warray-bounds exposes
a couple negative array index accesses:

arch/arm/mach-vexpress/spc.c: In function 've_spc_clk_init':
arch/arm/mach-vexpress/spc.c:583:21: warning: array subscript -1 is below array bounds of 'bool[2]' {aka '_Bool[2]'} [-Warray-bounds]
  583 |   if (init_opp_table[cluster])
      |       ~~~~~~~~~~~~~~^~~~~~~~~
arch/arm/mach-vexpress/spc.c:556:7: note: while referencing 'init_opp_table'
  556 |  bool init_opp_table[MAX_CLUSTERS] = { false };
      |       ^~~~~~~~~~~~~~
arch/arm/mach-vexpress/spc.c:592:18: warning: array subscript -1 is below array bounds of 'bool[2]' {aka '_Bool[2]'} [-Warray-bounds]
  592 |    init_opp_table[cluster] = true;
      |    ~~~~~~~~~~~~~~^~~~~~~~~
arch/arm/mach-vexpress/spc.c:556:7: note: while referencing 'init_opp_table'
  556 |  bool init_opp_table[MAX_CLUSTERS] = { false };
      |       ^~~~~~~~~~~~~~

Skip this logic when built !SMP.

Link: https://lore.kernel.org/r/20220331190443.851661-1-keescook@chromium.org
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-vexpress/spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 635b0d549487..c16f39614003 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -584,7 +584,7 @@ static int __init ve_spc_clk_init(void)
 		}
 
 		cluster = topology_physical_package_id(cpu_dev->id);
-		if (init_opp_table[cluster])
+		if (cluster < 0 || init_opp_table[cluster])
 			continue;
 
 		if (ve_init_opp_table(cpu_dev))
-- 
2.35.1

