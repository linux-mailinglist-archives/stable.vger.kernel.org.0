Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E85B84CA
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiINJRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiINJP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:15:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFE07E818;
        Wed, 14 Sep 2022 02:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B85F619BF;
        Wed, 14 Sep 2022 09:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677A2C433C1;
        Wed, 14 Sep 2022 09:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146392;
        bh=Jv25U57A8E5FSQtn7a/ssUiGqN6heQxDT8ZE7j/CpZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6GS4E5SJi5xB2KyATXN+3UIw5Y5gOiODjAcOrdw4AT1nxXaHQHYsFON0B85WQqbD
         ByLb0JnglxbE6Nzdx87LFFs0WhtL1u3B8+LK9xAwET+IooeKWG4SsY5qFgGxlpJXEj
         NTKjFiIytv9DWci9loJENvzg0uR7ocojRPUYg54i99MfHUixk8CYfGHMfdXb5mixIK
         82dxeD8Pfn0CruSBHDJXch8eze9koX/KO1LL6POB6AUkQF3xpTmVS+DrD99JzLvMQC
         2A3AU4v29sa5/EmIiu0VDRbJ+1fk2y6g35iKlIEwSIzoFNYswXurOsY7jLBk9ZgV+A
         zZQaaqGDYoRXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/13] mips: lantiq: Add missing of_node_put() in irq.c
Date:   Wed, 14 Sep 2022 05:05:39 -0400
Message-Id: <20220914090540.471725-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090540.471725-1-sashal@kernel.org>
References: <20220914090540.471725-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e64f678ca12c8..e29dc58271b2c 100644
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

