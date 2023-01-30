Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387C968101A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbjA3OAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbjA3OAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCAD2C64C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:59:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EB0661049
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F978C433EF;
        Mon, 30 Jan 2023 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087184;
        bh=fWKNo9YVWCEv3yEo+ZJpJE/0kVWmKsWjQOfVM5cqo9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfgdX3heW8sXJIGwM08/EHaJh276hm6FBynPFECXBcSPyPVlYEqiaT7PInOMzPbxc
         PZUpGTyBtelFdQzU2XYIHUbB3bm91thQQAgSHjR0+b4AtGGb9nZhRXkj2GwMdnGi/S
         06TMmaguv5vV5WFs9i4G9RWiA477MNGGIYbl5a8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/313] net: sched: gred: prevent races when adding offloads to stats
Date:   Mon, 30 Jan 2023 14:49:19 +0100
Message-Id: <20230130134342.418986216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 339346d49ae0859fe19b860998867861d37f1a76 ]

Naresh reports seeing a warning that gred is calling
u64_stats_update_begin() with preemption enabled.
Arnd points out it's coming from _bstats_update().

We should be holding the qdisc lock when writing
to stats, they are also updated from the datapath.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Link: https://lore.kernel.org/all/CA+G9fYsTr9_r893+62u6UGD3dVaCE-kN9C-Apmb2m=hxjc1Cqg@mail.gmail.com/
Fixes: e49efd5288bd ("net: sched: gred: support reporting stats from offloads")
Link: https://lore.kernel.org/r/20230113044137.1383067-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_gred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index a661b062cca8..872d127c9db4 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -377,6 +377,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 	/* Even if driver returns failure adjust the stats - in case offload
 	 * ended but driver still wants to adjust the values.
 	 */
+	sch_tree_lock(sch);
 	for (i = 0; i < MAX_DPs; i++) {
 		if (!table->tab[i])
 			continue;
@@ -393,6 +394,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 		sch->qstats.overlimits += hw_stats->stats.qstats[i].overlimits;
 	}
 	_bstats_update(&sch->bstats, bytes, packets);
+	sch_tree_unlock(sch);
 
 	kfree(hw_stats);
 	return ret;
-- 
2.39.0



