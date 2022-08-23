Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779F459DDC3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355817AbiHWKsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355775AbiHWKoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:44:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49B7AB044;
        Tue, 23 Aug 2022 02:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81870608D5;
        Tue, 23 Aug 2022 09:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C53C433C1;
        Tue, 23 Aug 2022 09:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245827;
        bh=PQwFh3y1zqnoCjaqteSP56ZnA2D0ZUNmXY2D9oi4lEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/Tk5gZMTqvEqXGPHIc0S44svBVwcf52ATTIM3a8Vx0co5bCYkA2ScXTI2Zxwfq1g
         ME1Ybx7VsSRPwd8sjNDxOTSNMcjeQ6sdhKHnp/IErsri9nw2c/9F9INmFTc7J7n+uq
         qkJQZmiT8EwwNweOcR+kHAMY7YDcFKVbEVhFf1M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenpeng Lin <zplin@u.northwestern.edu>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 201/287] net_sched: cls_route: remove from list when handle is 0
Date:   Tue, 23 Aug 2022 10:26:10 +0200
Message-Id: <20220823080107.633720163@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 9ad36309e2719a884f946678e0296be10f0bb4c1 upstream.

When a route filter is replaced and the old filter has a 0 handle, the old
one won't be removed from the hashtable, while it will still be freed.

The test was there since before commit 1109c00547fc ("net: sched: RCU
cls_route"), when a new filter was not allocated when there was an old one.
The old filter was reused and the reinserting would only be necessary if an
old filter was replaced. That was still wrong for the same case where the
old handle was 0.

Remove the old filter from the list independently from its handle value.

This fixes CVE-2022-2588, also reported as ZDI-CAN-17440.

Reported-by: Zhenpeng Lin <zplin@u.northwestern.edu>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reviewed-by: Kamal Mostafa <kamal@canonical.com>
Cc: <stable@vger.kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20220809170518.164662-1-cascardo@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -528,7 +528,7 @@ static int route4_change(struct net *net
 	rcu_assign_pointer(f->next, f1);
 	rcu_assign_pointer(*fp, f);
 
-	if (fold && fold->handle && f->handle != fold->handle) {
+	if (fold) {
 		th = to_hash(fold->handle);
 		h = from_hash(fold->handle >> 16);
 		b = rtnl_dereference(head->table[th]);


