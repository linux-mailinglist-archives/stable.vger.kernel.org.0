Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6C55D0D4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbiF1CbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbiF1C2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:28:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F1D25582;
        Mon, 27 Jun 2022 19:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 914E3B81C00;
        Tue, 28 Jun 2022 02:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA345C36AE5;
        Tue, 28 Jun 2022 02:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383248;
        bh=rrDhxUZ7JRFCLEk5L6AChGIzQ8M4z5nHZqc1JCT5t+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgnkk7tDsQ1VknCu282j2UlGrhAoQtCnZIFA6ELmih37VPeYJglYDYnRc09iOVH3o
         SEOcRFTd5A/uY7Z0pABHRw/qVODumQUimaFLwdGt+mVfvpyVkmULmNXy+zorqR8+GX
         4EbUniNve4Crel29hUbUQa3ITUuSjXW1VKzk3hKtN82OGXCXfk/qzTZ4rSaEGHK8Ub
         1EJqVJXyL3VAeYY8Rr7bW31NkfdGfDzW5W8QBDLlC+fkVZKKgmiaUao3pNc0+A9plY
         /DqrY4cSn3hxVIl1jiIasbJrCjlnUXTRBeD9Hb7T7vhf1tHhngpG/ODJ9IPSISatt8
         TzKob27GgYlcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/13] mips: lantiq: Add missing of_node_put() in irq.c
Date:   Mon, 27 Jun 2022 22:26:56 -0400
Message-Id: <20220628022657.597208-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022657.597208-1-sashal@kernel.org>
References: <20220628022657.597208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 3748d2185ac4c2c6f80989672253aad909ecaf95 ]

In icu_of_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index e64f678ca12c..e29dc58271b2 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -460,6 +460,7 @@ int __init icu_of_init(struct device_node *node, struct device_node *parent)
 		if (!ltq_eiu_membase)
 			panic("Failed to remap eiu memory");
 	}
+	of_node_put(eiu_node);
 
 	return 0;
 }
-- 
2.35.1

