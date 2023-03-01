Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D775B6A72D7
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCASKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCASJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8402E6A64
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B50461466
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E17C433EF;
        Wed,  1 Mar 2023 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694193;
        bh=NJ78B2NbJU6Bl2N24WBg8IKyUxGxfFV2X68ynotAkng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLa3BSFkT/WVF+gsm4n0L/O7Kxk1LnEegFrY+7U+zzxRg62fRxpSGiuq+hlsnSb2Q
         zOM011BxMNovDVu+pqVJx5Am1OluOXNsm3EXHZ5bne8vL7+tmB25ZHKYzp5f8/3gOH
         NpBbJRO1KJz4AYi2v/TxppYQWd8F1OO2FCdXXkqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/19] neigh: make sure used and confirmed times are valid
Date:   Wed,  1 Mar 2023 19:08:36 +0100
Message-Id: <20230301180652.632591438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit c1d2ecdf5e38e3489ce8328238b558b3b2866fe1 ]

Entries can linger in cache without timer for days, thanks to
the gc_thresh1 limit. As result, without traffic, the confirmed
time can be outdated and to appear to be in the future. Later,
on traffic, NUD_STALE entries can switch to NUD_DELAY and start
the timer which can see the invalid confirmed time and wrongly
switch to NUD_REACHABLE state instead of NUD_PROBE. As result,
timer is set many days in the future. This is more visible on
32-bit platforms, with higher HZ value.

Why this is a problem? While we expect unused entries to expire,
such entries stay in REACHABLE state for too long, locked in
cache. They are not expired normally, only when cache is full.

Problem and the wrong state change reported by Zhang Changzhong:

172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE

350520 seconds have elapsed since this entry was last updated, but it is
still in the REACHABLE state (base_reachable_time_ms is 30000),
preventing lladdr from being updated through probe.

Fix it by ensuring timer is started with valid used/confirmed
times. Considering the valid time range is LONG_MAX jiffies,
we try not to go too much in the past while we are in
DELAY/PROBE state. There are also places that need
used/updated times to be validated while timer is not running.

Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Tested-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f6f580e9d2820..82ccc3eebe71d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -242,7 +242,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 			    (n->nud_state == NUD_NOARP) ||
 			    (tbl->is_multicast &&
 			     tbl->is_multicast(n->primary_key)) ||
-			    time_after(tref, n->updated))
+			    !time_in_range(n->updated, tref, jiffies))
 				remove = true;
 			write_unlock(&n->lock);
 
@@ -262,7 +262,17 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 static void neigh_add_timer(struct neighbour *n, unsigned long when)
 {
+	/* Use safe distance from the jiffies - LONG_MAX point while timer
+	 * is running in DELAY/PROBE state but still show to user space
+	 * large times in the past.
+	 */
+	unsigned long mint = jiffies - (LONG_MAX - 86400 * HZ);
+
 	neigh_hold(n);
+	if (!time_in_range(n->confirmed, mint, jiffies))
+		n->confirmed = mint;
+	if (time_before(n->used, n->confirmed))
+		n->used = n->confirmed;
 	if (unlikely(mod_timer(&n->timer, when))) {
 		printk("NEIGH: BUG, double timer add, state is %x\n",
 		       n->nud_state);
@@ -948,12 +958,14 @@ static void neigh_periodic_work(struct work_struct *work)
 				goto next_elt;
 			}
 
-			if (time_before(n->used, n->confirmed))
+			if (time_before(n->used, n->confirmed) &&
+			    time_is_before_eq_jiffies(n->confirmed))
 				n->used = n->confirmed;
 
 			if (refcount_read(&n->refcnt) == 1 &&
 			    (state == NUD_FAILED ||
-			     time_after(jiffies, n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
+			     !time_in_range_open(jiffies, n->used,
+						 n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
 				*np = n->next;
 				neigh_mark_dead(n);
 				write_unlock(&n->lock);
-- 
2.39.0



