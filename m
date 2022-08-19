Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAC9599F46
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351001AbiHSP7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350753AbiHSP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:58:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5324108F80;
        Fri, 19 Aug 2022 08:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DCFE61732;
        Fri, 19 Aug 2022 15:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567A6C433D6;
        Fri, 19 Aug 2022 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924312;
        bh=14BO3jFRo9LTUBo+dV5YyJ4Ptn7JKSUmnCiFGI1LRj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtutzwNuxk3GOsEL53rdHTY1O6KgoWcxkSYd3k+qt+u5lOYOb1ysbrzbpYagXoIcQ
         1+SV4MoW1d2WpmpoXS38eFF5Tj7JEO0Q67Jt2OG0+6V/Tf2M2xG1Ama2yVBxHWhYpD
         TOMuJMMEPina8lENCFExIwQFzhRc6kGfsLkMuKD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/545] cpufreq: zynq: Fix refcount leak in zynq_get_revision
Date:   Fri, 19 Aug 2022 17:38:19 +0200
Message-Id: <20220819153835.099495278@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit d1ff2559cef0f6f8d97fba6337b28adb10689e16 ]

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 00f7dc636366 ("ARM: zynq: Add support for SOC_BUS")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220605082807.21526-1-linmq006@gmail.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-zynq/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index e1ca6a5732d2..15e8a321a713 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -77,6 +77,7 @@ static int __init zynq_get_revision(void)
 	}
 
 	zynq_devcfg_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!zynq_devcfg_base) {
 		pr_err("%s: Unable to map I/O memory\n", __func__);
 		return -1;
-- 
2.35.1



