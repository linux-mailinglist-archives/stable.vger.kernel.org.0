Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E5507822
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354157AbiDSSZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357393AbiDSSXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:23:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4009343AE3;
        Tue, 19 Apr 2022 11:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 670E760DBC;
        Tue, 19 Apr 2022 18:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6496C385A5;
        Tue, 19 Apr 2022 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392160;
        bh=aj2MJe6FxnGwrXKvMahFbCQYAaT+4ocJ3YhgWHEGcDc=;
        h=From:To:Cc:Subject:Date:From;
        b=fp8mxRkjcYkbtsZl0FjckEfUPWSi+Jw8XsNUoyBNgujBjbaHzwMCeYCbXSclSRloF
         8tv2ZUvfIA4txs8YefNGSLYwKHJQNFXOky59NiKXRfdVLg3fyqY0HBRFIvRuH6wvDW
         hJsctZMKu2VzLh3lSnhL4qz0jGU5lf1fuhVRSJagmMGBRM8CWfL2ayAaWozwyWquJw
         qXlCzXFSPGX6ryGwrtoC2WD0DPRQujPUIlJ/pSF+Tq2w8vFP2QbmNKbEmeLGOeXBVD
         r76BGqaKSGzYnwKrZbMaDRA0xy/jVa4yTboIyvFG5EwzytIgBrzOrngx9Z0SIH4fdT
         exgpudwdgS4rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 1/9] ARM: vexpress/spc: Avoid negative array index when !SMP
Date:   Tue, 19 Apr 2022 14:15:49 -0400
Message-Id: <20220419181557.486336-1-sashal@kernel.org>
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

