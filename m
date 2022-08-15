Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC75944AC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350752AbiHOWsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352055AbiHOWrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC67135AD8;
        Mon, 15 Aug 2022 12:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BBB16122B;
        Mon, 15 Aug 2022 19:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D82C433D6;
        Mon, 15 Aug 2022 19:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593199;
        bh=omZ20BVuFxL1W05Lz9Iqe5y6+N9MFAhSKFKp3+JoWnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjHDDuP+Z2xP2SP4JlUva7mkOsiTZsL/fJ6z0YIYX27c232NAWOFTSiZhzZLe6d6Z
         7+h4UwafHx2WplsvaPwBqZav0rntjSjkmtcQccjVkYo71aa75HkYX6sZL8roswU+UR
         ufgeZ367EE/rTaG7zqs9JYVmATbOa19Wi+u+V+Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0229/1157] ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
Date:   Mon, 15 Aug 2022 19:53:05 +0200
Message-Id: <20220815180448.736280735@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 1b442b128569..63e73e9b82bc 100644
--- a/arch/arm/mach-omap2/prm3xxx.c
+++ b/arch/arm/mach-omap2/prm3xxx.c
@@ -708,6 +708,7 @@ static int omap3xxx_prm_late_init(void)
 	}
 
 	irq_num = of_irq_get(np, 0);
+	of_node_put(np);
 	if (irq_num == -EPROBE_DEFER)
 		return irq_num;
 
-- 
2.35.1



