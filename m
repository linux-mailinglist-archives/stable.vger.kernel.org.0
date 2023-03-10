Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7D16B41B7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCJNzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjCJNzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:55:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A062010F475
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE77B822B9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86656C433EF;
        Fri, 10 Mar 2023 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456524;
        bh=NP4P2s9LfI66JnA7bcRK68Z6EJWM1pEy3e3+6m3epxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1clLjv8sQKM7qLovOxG67aKHF3RZDNTuUZKZGAXQiamlyP/EIv54Ktq3yNa0awaEY
         1VpQn3cC2P2GrP/GVlv8xs1EHD50CCRI4L93OZTVBc/WUrGOO75qDcXoJaOyvA/olU
         ELYqOfMaWuFq+oHEhhLkn6gaujTMS8QqCIsLPcsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 032/211] ubifs: Reserve one leb for each journal head while doing budget
Date:   Fri, 10 Mar 2023 14:36:52 +0100
Message-Id: <20230310133719.715136713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit e874dcde1cbf82c786c0e7f2899811c02630cc52 ]

UBIFS calculates available space by c->main_bytes - c->lst.total_used
(which means non-index lebs' free and dirty space is accounted into
total available), then index lebs and four lebs (one for gc_lnum, one
for deletions, two for journal heads) are deducted.
In following situation, ubifs may get -ENOSPC from make_reservation():
 LEB 84: DATAHD   free 122880 used 1920  dirty 2176  dark 6144
 LEB 110:DELETION free 126976 used 0     dirty 0     dark 6144 (empty)
 LEB 201:gc_lnum  free 126976 used 0     dirty 0     dark 6144
 LEB 272:GCHD     free 77824  used 47672 dirty 1480  dark 6144
 LEB 356:BASEHD   free 0      used 39776 dirty 87200 dark 6144
 OTHERS: index lebs, zero-available non-index lebs

UBIFS calculates the available bytes is 6888 (How to calculate it:
126976 * 5[remain main bytes] - 1920[used] - 47672[used] - 39776[used] -
126976 * 1[deletions] - 126976 * 1[gc_lnum] - 126976 * 2[journal heads]
- 6144 * 5[dark] = 6888) after doing budget, however UBIFS cannot use
BASEHD's dirty space(87200), because UBIFS cannot find next BASEHD to
reclaim current BASEHD. (c->bi.min_idx_lebs equals to c->lst.idx_lebs,
the empty leb won't be found by ubifs_find_free_space(), and dirty index
lebs won't be picked as gced lebs. All non-index lebs has dirty space
less then c->dead_wm, non-index lebs won't be picked as gced lebs
either. So new free lebs won't be produced.). See more details in Link.

To fix it, reserve one leb for each journal head while doing budget.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216562
Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/budget.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 986e6e4081c76..d76eb7b39f564 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -209,11 +209,10 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
 	subtract_lebs += 1;
 
 	/*
-	 * The GC journal head LEB is not really accessible. And since
-	 * different write types go to different heads, we may count only on
-	 * one head's space.
+	 * Since different write types go to different heads, we should
+	 * reserve one leb for each head.
 	 */
-	subtract_lebs += c->jhead_cnt - 1;
+	subtract_lebs += c->jhead_cnt;
 
 	/* We also reserve one LEB for deletions, which bypass budgeting */
 	subtract_lebs += 1;
-- 
2.39.2



