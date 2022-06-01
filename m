Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581B753A866
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354538AbiFAOIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354586AbiFAOH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:07:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB55A3388;
        Wed,  1 Jun 2022 07:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652FA61632;
        Wed,  1 Jun 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C14C385A5;
        Wed,  1 Jun 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092015;
        bh=SpEc8xwd/DWXEBIER3O/kILG2B+8H0RsWfZGILzBquk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNCOtMUBNfHRR16Mw+2aTgbriJFfDLe6bTCatnXOeHaXpWfDSGhUHMrE00tQY9Fnq
         wfGGbliQHptvmPV3vo1KJSInR6hsMaAXBVN39RP/F67jIolJwQfKw5j+URRLJi/6ub
         n+xEYPrIRSt4xCFnVZ1YhxgxTar9M5S5KcjRcAjda+9MzP962Wz/KqSjQU5cvfgadC
         /wke+d0fVncQEkY4eZWx0jG5mfzWtQZ/gfQonN/S5tJryLlwn+IoQKXU6frr9voO71
         PqN2Jlnt8o+arK9JsPUiM5w0AZ6jiuxlk3cKRjK1GRNtjpyKiu5f+ZNdGvzqUhPW9r
         VMzKcskrABfLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nick.child@ibm.com,
        maz@kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 12/15] powerpc/xics: fix refcount leak in icp_opal_init()
Date:   Wed,  1 Jun 2022 09:59:47 -0400
Message-Id: <20220601135951.2005085-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135951.2005085-1-sashal@kernel.org>
References: <20220601135951.2005085-1-sashal@kernel.org>
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 5dd9e27ea4a39f7edd4bf81e9e70208e7ac0b7c9 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, use of_node_put() on it when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220402013419.2410298-1-lv.ruyi@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-opal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xics/icp-opal.c b/arch/powerpc/sysdev/xics/icp-opal.c
index e3e52cf035a9..672d8aedae12 100644
--- a/arch/powerpc/sysdev/xics/icp-opal.c
+++ b/arch/powerpc/sysdev/xics/icp-opal.c
@@ -199,6 +199,7 @@ int icp_opal_init(void)
 
 	printk("XICS: Using OPAL ICP fallbacks\n");
 
+	of_node_put(np);
 	return 0;
 }
 
-- 
2.35.1

