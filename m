Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEE06AE819
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCGRNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCGRMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7624C98
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FB2EB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B30AC433EF;
        Tue,  7 Mar 2023 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208844;
        bh=37AzPDB6qsEfN8uuFhA/55KyMtG4UOzpPHgcE+i4lvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oj5JskI4x4PArqBrGdkOif23g7V7IZAKT0h8m2K37p7G43YuRuU9rNtSSP+o4w7vP
         MquqOC8dN/pOfgXv66Y+GJLhkGxwKs5rXto7sbDqqy7KPtmiDyfNjn6VK/ftJCnt1A
         4PIGAskM1ad8dtV0aEEyxP/+MFjzz0D0XSawyGwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Hui <judy.chenhui@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0009/1001] ARM: OMAP2+: Fix memory leak in realtime_counter_init()
Date:   Tue,  7 Mar 2023 17:46:21 +0100
Message-Id: <20230307170022.547479261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Hui <judy.chenhui@huawei.com>

[ Upstream commit ed8167cbf65c2b6ff6faeb0f96ded4d6d581e1ac ]

The "sys_clk" resource is malloced by clk_get(),
it is not released when the function return.

Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time counter.")
Signed-off-by: Chen Hui <judy.chenhui@huawei.com>
Message-Id: <20221108141917.46796-1-judy.chenhui@huawei.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 620ba69c8f114..5677c4a08f376 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -76,6 +76,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
-- 
2.39.2



