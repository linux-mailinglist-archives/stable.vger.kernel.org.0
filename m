Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B591059A257
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352285AbiHSQeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352588AbiHSQch (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:32:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D01211FD26;
        Fri, 19 Aug 2022 09:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 078D7617A5;
        Fri, 19 Aug 2022 16:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F57C433D7;
        Fri, 19 Aug 2022 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925218;
        bh=hs0xlTw8lysVrybK2TgpmR7OaRUhu3dPDetYyXnmT4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vj55nG/LIgWKMqJxirnrm5JYXtb7T0ai6bAL2MPrEqJrYuCu730S7KqWmMf23FdaS
         SYI7jx7i9GE3X0TMe+HeW97eX4CNAraiYtT4Rj7zVyZR/poY1R5UFSMrbgOW6dvQsD
         UlBrOqTKpD046C3mCS3T2kNC/3yDyQnHKVKcVRT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/545] powerpc/xive: Fix refcount leak in xive_get_max_prio
Date:   Fri, 19 Aug 2022 17:43:12 +0200
Message-Id: <20220819153848.305719024@linuxfoundation.org>
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

[ Upstream commit 255b650cbec6849443ce2e0cdd187fd5e61c218c ]

of_find_node_by_path() returns a node pointer with
refcount incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220605053225.56125-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/spapr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index b57eeaff7bb3..38e8b9896174 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -710,6 +710,7 @@ static bool xive_get_max_prio(u8 *max_prio)
 	}
 
 	reg = of_get_property(rootdn, "ibm,plat-res-int-priorities", &len);
+	of_node_put(rootdn);
 	if (!reg) {
 		pr_err("Failed to read 'ibm,plat-res-int-priorities' property\n");
 		return false;
-- 
2.35.1



