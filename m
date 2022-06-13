Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F8C549500
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376845AbiFMNdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378113AbiFMNax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7D313D6A;
        Mon, 13 Jun 2022 04:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE5E60F18;
        Mon, 13 Jun 2022 11:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E52C36B07;
        Mon, 13 Jun 2022 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119537;
        bh=b/9qIeG94uHBo4HSzdZoF9DK2yKWhDCwVZXzJ95coXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcjtbUIL9ahrf5EWb11Q/dNj8ArcwREoAqq1T3TmX0CFY1oFH93FrMJlfzlWijVQ6
         Pa1J/lnL6Iip74bJva+Ml/tog+hjq580YykE94y5s2BrNplaX2KGwhEZtFlIueh7ko
         PxyTEmz26y+F4Mi7TmTyNFDsx2kVHhGP0RKUPTKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 029/339] firmware: stratix10-svc: fix a missing check on list iterator
Date:   Mon, 13 Jun 2022 12:07:34 +0200
Message-Id: <20220613094927.397080499@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit 5a0793ac66ac0e254d292f129a4d6c526f9f2aff ]

The bug is here:
	pmem->vaddr = NULL;

The list iterator 'pmem' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will
lead to a invalid memory access.

To fix this bug, just gen_pool_free/set NULL/list_del() and return
when found, otherwise list_del HEAD and return;

Fixes: 7ca5ce896524f ("firmware: add Intel Stratix10 service layer driver")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220414035609.2239-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 8177a0fae11d..14663f671323 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -948,17 +948,17 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate_memory);
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
-	size_t size = 0;
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {
-			size = pmem->size;
-			break;
+			gen_pool_free(chan->ctrl->genpool,
+				       (unsigned long)kaddr, pmem->size);
+			pmem->vaddr = NULL;
+			list_del(&pmem->node);
+			return;
 		}
 
-	gen_pool_free(chan->ctrl->genpool, (unsigned long)kaddr, size);
-	pmem->vaddr = NULL;
-	list_del(&pmem->node);
+	list_del(&svc_data_mem);
 }
 EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
 
-- 
2.35.1



