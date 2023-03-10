Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8426B4300
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjCJOJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjCJOJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804B81FD8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1201F6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2313CC4339E;
        Fri, 10 Mar 2023 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457322;
        bh=T1UvVUZq879g5HlfmSbqGqSsR3xI/xu1OA63map/8xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSUrV8Tn5QlogyMjs/8PYih7LJITQiivgYfskhBmpFrOnNb25RiSefF5M+9+v1rBq
         WZd2rX/okqCWZprzmGlh24trYdKVoaZ5nwSS6AfLc3P/oKQKBQzpzlYY25jkCzSij+
         wOxM4EM+jRpRkONzTlspYsHOk5PvsSu1u8j2UY7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yalin Li <yalli@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/200] ptp: vclock: use mutex to fix "sleep on atomic" bug
Date:   Fri, 10 Mar 2023 14:37:54 +0100
Message-Id: <20230310133719.184008663@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 67d93ffc0f3c47094750bde6d62e7c5765dc47a6 ]

vclocks were using spinlocks to protect access to its timecounter and
cyclecounter. Access to timecounter/cyclecounter is backed by the same
driver callbacks that are used for non-virtual PHCs, but the usage of
the spinlock imposes a new limitation that didn't exist previously: now
they're called in atomic context so they mustn't sleep.

Some drivers like sfc or ice may sleep on these callbacks, causing
errors like "BUG: scheduling while atomic: ptp5/25223/0x00000002"

Fix it replacing the vclock's spinlock by a mutex. It fix the mentioned
bug and it doesn't introduce longer delays.

I've tested synchronizing various different combinations of clocks:
- vclock->sysclock
- sysclock->vclock
- vclock->vclock
- hardware PHC in different NIC -> vclock
- created 4 vclocks and launch 4 parallel phc2sys processes with
  lockdep enabled

In all cases, comparing the delays reported by phc2sys, they are in the
same range of values than before applying the patch.

Link: https://lore.kernel.org/netdev/69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com/
Fixes: 5d43f951b1ac ("ptp: add ptp virtual clock driver framework")
Reported-by: Yalin Li <yalli@redhat.com>
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20230221130616.21837-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h |  2 +-
 drivers/ptp/ptp_vclock.c  | 44 +++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 77918a2c67018..75f58fc468a71 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -66,7 +66,7 @@ struct ptp_vclock {
 	struct hlist_node vclock_hash_node;
 	struct cyclecounter cc;
 	struct timecounter tc;
-	spinlock_t lock;	/* protects tc/cc */
+	struct mutex lock;	/* protects tc/cc */
 };
 
 /*
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 1c0ed4805c0aa..dcf752c9e0450 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -43,16 +43,16 @@ static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
 static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 	s64 adj;
 
 	adj = (s64)scaled_ppm << PTP_VCLOCK_FADJ_SHIFT;
 	adj = div_s64(adj, PTP_VCLOCK_FADJ_DENOMINATOR);
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	timecounter_read(&vclock->tc);
 	vclock->cc.mult = PTP_VCLOCK_CC_MULT + adj;
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -60,11 +60,11 @@ static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 static int ptp_vclock_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	timecounter_adjtime(&vclock->tc, delta);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -73,12 +73,12 @@ static int ptp_vclock_gettime(struct ptp_clock_info *ptp,
 			      struct timespec64 *ts)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 	u64 ns;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	ns = timecounter_read(&vclock->tc);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 	*ts = ns_to_timespec64(ns);
 
 	return 0;
@@ -91,7 +91,6 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
 	struct timespec64 pts;
-	unsigned long flags;
 	int err;
 	u64 ns;
 
@@ -99,9 +98,10 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	ns = timecounter_cyc2time(&vclock->tc, timespec64_to_ns(&pts));
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -113,11 +113,11 @@ static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	u64 ns = timespec64_to_ns(ts);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	timecounter_init(&vclock->tc, &vclock->cc, ns);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -127,7 +127,6 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
-	unsigned long flags;
 	int err;
 	u64 ns;
 
@@ -135,9 +134,10 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	ns = timecounter_cyc2time(&vclock->tc, ktime_to_ns(xtstamp->device));
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	xtstamp->device = ns_to_ktime(ns);
 
@@ -205,7 +205,7 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	INIT_HLIST_NODE(&vclock->vclock_hash_node);
 
-	spin_lock_init(&vclock->lock);
+	mutex_init(&vclock->lock);
 
 	vclock->clock = ptp_clock_register(&vclock->info, &pclock->dev);
 	if (IS_ERR_OR_NULL(vclock->clock)) {
@@ -269,7 +269,6 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
 	unsigned int hash = vclock_index % HASH_SIZE(vclock_hash);
 	struct ptp_vclock *vclock;
-	unsigned long flags;
 	u64 ns;
 	u64 vclock_ns = 0;
 
@@ -281,9 +280,10 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 		if (vclock->clock->index != vclock_index)
 			continue;
 
-		spin_lock_irqsave(&vclock->lock, flags);
+		if (mutex_lock_interruptible(&vclock->lock))
+			break;
 		vclock_ns = timecounter_cyc2time(&vclock->tc, ns);
-		spin_unlock_irqrestore(&vclock->lock, flags);
+		mutex_unlock(&vclock->lock);
 		break;
 	}
 
-- 
2.39.2



