Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB921780F7
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387670AbgCCR7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387667AbgCCR7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:59:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F4A20656;
        Tue,  3 Mar 2020 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258391;
        bh=aB3TXAkzTHdlcxoRAps//aXWMLGnkW/Qazh6jB3T+1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdZVyfoC7cSxLVJYq9k0+tlo/wvKYZoo3lPXZzLBlzgf2G7RYcnil2UIJTrxWROQy
         LkdGJGk/lEbJNwQxQ28kDlhIqKK6n1zlVENpkhEgzaNL+uf1PGhDmpUUBXzWxeeAIa
         132y4duIbXPrewphU98j4eH0mWo+h0ragZ27iZAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/87] s390/zcrypt: fix card and queue total counter wrap
Date:   Tue,  3 Mar 2020 18:43:00 +0100
Message-Id: <20200303174349.864204285@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit fcd98d4002539f1e381916fc1b6648938c1eac76 ]

The internal statistic counters for the total number of
requests processed per card and per queue used integers. So they do
wrap after a rather huge amount of crypto requests processed. This
patch introduces uint64 counters which should hold much longer but
still may wrap. The sysfs attributes request_count for card and queue
also used only %ld and now display the counter value with %llu.

This is not a security relevant fix. The int overflow which happened
is not in any way exploitable as a security breach.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.h     |  4 ++--
 drivers/s390/crypto/ap_card.c    |  8 ++++----
 drivers/s390/crypto/ap_queue.c   |  6 +++---
 drivers/s390/crypto/zcrypt_api.c | 16 +++++++++-------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 7e85d238767ba..1c799ddd97092 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -158,7 +158,7 @@ struct ap_card {
 	unsigned int functions;		/* AP device function bitfield. */
 	int queue_depth;		/* AP queue depth.*/
 	int id;				/* AP card number. */
-	atomic_t total_request_count;	/* # requests ever for this AP device.*/
+	atomic64_t total_request_count;	/* # requests ever for this AP device.*/
 };
 
 #define to_ap_card(x) container_of((x), struct ap_card, ap_dev.device)
@@ -175,7 +175,7 @@ struct ap_queue {
 	enum ap_state state;		/* State of the AP device. */
 	int pendingq_count;		/* # requests on pendingq list. */
 	int requestq_count;		/* # requests on requestq list. */
-	int total_request_count;	/* # requests ever for this AP device.*/
+	u64 total_request_count;	/* # requests ever for this AP device.*/
 	int request_timeout;		/* Request timeout in jiffies. */
 	struct timer_list timeout;	/* Timer for request timeouts. */
 	struct list_head pendingq;	/* List of message sent to AP queue. */
diff --git a/drivers/s390/crypto/ap_card.c b/drivers/s390/crypto/ap_card.c
index 63b4cc6cd7e59..e85bfca1ed163 100644
--- a/drivers/s390/crypto/ap_card.c
+++ b/drivers/s390/crypto/ap_card.c
@@ -63,13 +63,13 @@ static ssize_t request_count_show(struct device *dev,
 				  char *buf)
 {
 	struct ap_card *ac = to_ap_card(dev);
-	unsigned int req_cnt;
+	u64 req_cnt;
 
 	req_cnt = 0;
 	spin_lock_bh(&ap_list_lock);
-	req_cnt = atomic_read(&ac->total_request_count);
+	req_cnt = atomic64_read(&ac->total_request_count);
 	spin_unlock_bh(&ap_list_lock);
-	return snprintf(buf, PAGE_SIZE, "%d\n", req_cnt);
+	return snprintf(buf, PAGE_SIZE, "%llu\n", req_cnt);
 }
 
 static ssize_t request_count_store(struct device *dev,
@@ -83,7 +83,7 @@ static ssize_t request_count_store(struct device *dev,
 	for_each_ap_queue(aq, ac)
 		aq->total_request_count = 0;
 	spin_unlock_bh(&ap_list_lock);
-	atomic_set(&ac->total_request_count, 0);
+	atomic64_set(&ac->total_request_count, 0);
 
 	return count;
 }
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 576ac08777c50..e1647da122f7f 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -470,12 +470,12 @@ static ssize_t request_count_show(struct device *dev,
 				  char *buf)
 {
 	struct ap_queue *aq = to_ap_queue(dev);
-	unsigned int req_cnt;
+	u64 req_cnt;
 
 	spin_lock_bh(&aq->lock);
 	req_cnt = aq->total_request_count;
 	spin_unlock_bh(&aq->lock);
-	return snprintf(buf, PAGE_SIZE, "%d\n", req_cnt);
+	return snprintf(buf, PAGE_SIZE, "%llu\n", req_cnt);
 }
 
 static ssize_t request_count_store(struct device *dev,
@@ -667,7 +667,7 @@ void ap_queue_message(struct ap_queue *aq, struct ap_message *ap_msg)
 	list_add_tail(&ap_msg->list, &aq->requestq);
 	aq->requestq_count++;
 	aq->total_request_count++;
-	atomic_inc(&aq->card->total_request_count);
+	atomic64_inc(&aq->card->total_request_count);
 	/* Send/receive as many request from the queue as possible. */
 	ap_wait(ap_sm_event_loop(aq, AP_EVENT_POLL));
 	spin_unlock_bh(&aq->lock);
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index b2737bfeb8bb6..23c24a699cefe 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -190,8 +190,8 @@ static inline bool zcrypt_card_compare(struct zcrypt_card *zc,
 	weight += atomic_read(&zc->load);
 	pref_weight += atomic_read(&pref_zc->load);
 	if (weight == pref_weight)
-		return atomic_read(&zc->card->total_request_count) >
-			atomic_read(&pref_zc->card->total_request_count);
+		return atomic64_read(&zc->card->total_request_count) >
+			atomic64_read(&pref_zc->card->total_request_count);
 	return weight > pref_weight;
 }
 
@@ -719,11 +719,12 @@ static void zcrypt_qdepth_mask(char qdepth[], size_t max_adapters)
 	spin_unlock(&zcrypt_list_lock);
 }
 
-static void zcrypt_perdev_reqcnt(int reqcnt[], size_t max_adapters)
+static void zcrypt_perdev_reqcnt(u32 reqcnt[], size_t max_adapters)
 {
 	struct zcrypt_card *zc;
 	struct zcrypt_queue *zq;
 	int card;
+	u64 cnt;
 
 	memset(reqcnt, 0, sizeof(int) * max_adapters);
 	spin_lock(&zcrypt_list_lock);
@@ -735,8 +736,9 @@ static void zcrypt_perdev_reqcnt(int reqcnt[], size_t max_adapters)
 			    || card >= max_adapters)
 				continue;
 			spin_lock(&zq->queue->lock);
-			reqcnt[card] = zq->queue->total_request_count;
+			cnt = zq->queue->total_request_count;
 			spin_unlock(&zq->queue->lock);
+			reqcnt[card] = (cnt < UINT_MAX) ? (u32) cnt : UINT_MAX;
 		}
 	}
 	local_bh_enable();
@@ -907,9 +909,9 @@ static long zcrypt_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		return 0;
 	}
 	case ZCRYPT_PERDEV_REQCNT: {
-		int *reqcnt;
+		u32 *reqcnt;
 
-		reqcnt = kcalloc(AP_DEVICES, sizeof(int), GFP_KERNEL);
+		reqcnt = kcalloc(AP_DEVICES, sizeof(u32), GFP_KERNEL);
 		if (!reqcnt)
 			return -ENOMEM;
 		zcrypt_perdev_reqcnt(reqcnt, AP_DEVICES);
@@ -966,7 +968,7 @@ static long zcrypt_unlocked_ioctl(struct file *filp, unsigned int cmd,
 	}
 	case Z90STAT_PERDEV_REQCNT: {
 		/* the old ioctl supports only 64 adapters */
-		int reqcnt[MAX_ZDEV_CARDIDS];
+		u32 reqcnt[MAX_ZDEV_CARDIDS];
 
 		zcrypt_perdev_reqcnt(reqcnt, MAX_ZDEV_CARDIDS);
 		if (copy_to_user((int __user *) arg, reqcnt, sizeof(reqcnt)))
-- 
2.20.1



