Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE94250F536
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbiDZInN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345360AbiDZIl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A008814AC;
        Tue, 26 Apr 2022 01:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 178D1618C1;
        Tue, 26 Apr 2022 08:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0915FC385A4;
        Tue, 26 Apr 2022 08:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961989;
        bh=y4FzcMqIYjP6yJMMswEni40ksnSonHHl5KEbQHYCCgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAAZTBAix+J9y0VTxlIVpI760LLcyd6siEyLGn6Rsk1l5QbDxMe23SGgPzPGsLnkS
         6MD9FoOn5RsGHReJY8Mu0pwh1u8z4IH88P5APGBC7/wrPW03j+6m5CWd/jOIHG9W6r
         iX4dHtUu1PdX8ZV4nxALA0BBHzaHU3npUxG1dEUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/86] ARM: vexpress/spc: Avoid negative array index when !SMP
Date:   Tue, 26 Apr 2022 10:21:02 +0200
Message-Id: <20220426081742.190193542@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 1da11bdb1dfb..1c6500c4e6a1 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -580,7 +580,7 @@ static int __init ve_spc_clk_init(void)
 		}
 
 		cluster = topology_physical_package_id(cpu_dev->id);
-		if (init_opp_table[cluster])
+		if (cluster < 0 || init_opp_table[cluster])
 			continue;
 
 		if (ve_init_opp_table(cpu_dev))
-- 
2.35.1



