Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9710659E218
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354178AbiHWKY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354540AbiHWKVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64ED582760;
        Tue, 23 Aug 2022 02:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBB92B81C54;
        Tue, 23 Aug 2022 09:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44554C433D6;
        Tue, 23 Aug 2022 09:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245376;
        bh=Bj8CgMYA2fxI+RpD8jD7zNYFs0yEL1HzpHHAhRb91yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bpwo9tDNn1vU+qYyxtMu6Qsf31JTNSToqHkU8swsJ2yvg8A0ljzg9m3o+k2ACtDdA
         hYHv4MkInfjGvIcnEV5m+oTMyt65z4XL2MU2/52Qkj/AHY1Un9la0NaW2wmdPWWwcq
         25vnC3jKEyyopzucG1HSfKMSscXBlIg8/Q3JeiPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/287] ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
Date:   Tue, 23 Aug 2022 10:23:48 +0200
Message-Id: <20220823080102.224716596@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 942228fbf5d4901112178b93d41225be7c0dd9de ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 1e037794f7f0 ("ARM: OMAP3+: PRM: register interrupt information from DT")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20220526073724.21169-1-linmq006@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/prm3xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/prm3xxx.c b/arch/arm/mach-omap2/prm3xxx.c
index dfa65fc2c82b..30445849b5e3 100644
--- a/arch/arm/mach-omap2/prm3xxx.c
+++ b/arch/arm/mach-omap2/prm3xxx.c
@@ -711,6 +711,7 @@ static int omap3xxx_prm_late_init(void)
 	}
 
 	irq_num = of_irq_get(np, 0);
+	of_node_put(np);
 	if (irq_num == -EPROBE_DEFER)
 		return irq_num;
 
-- 
2.35.1



