Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6157445C98D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhKXQNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhKXQNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 11:13:37 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45358C061714
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:10:27 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z18so3884914iof.5
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=5JFV8OOrlpEiXRvxxXIRx3QBohQI3UDhC+RUdQmv1J0=;
        b=pSHombFXI+tPzc1zNv3rt9mv0LondDWOecIqVn5Vgmg86q1c+Ws1fe/LTjDaprRGzb
         wL6ytwVSAE0lZ/Mq5eoEk7ShOYSOEF2tQFXlTjEacHMFx8yBkzPrA5z38FRGXgbTkRsu
         /mrJENkz91+kDiGYbzOqMx3yss8+ZuHLBwefnsxTgWnnBi8gEaeZl5/D3Bp1P/FO0z8s
         RSLs7wPTztgmsZdy2ti/IdQ+VtWKekTOWpuM6a7kT/cTGExzr2BYlRgh6psnmfKR6Jhl
         1mW5cdAWK5HrYzRe2wh3l6Itsq5BaW+S0w81SobvINkNPb/SES3C1jpUppv2rGfouDeZ
         7k2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=5JFV8OOrlpEiXRvxxXIRx3QBohQI3UDhC+RUdQmv1J0=;
        b=R8Flc3crovjwG7rTGjwN9ZBFA1BTTP/8plFkj+rRium2EBDGrcdHOVB7UMZJ+PwATk
         /4FDDuDJOcqNGDkdZ6n87vcCOVmGXuhoPiTPVZPeE1VMPDDKAk57hB+netB3l1Yhg2TB
         +G1UJFdXnW/Dgr1b5GdTQ2JaAJITP5iMZ1jLGuJFpqmd9EJ23jAwTeaWnQ4/R/gA06an
         2FNzPheHnDHfVjaEOvKo05w9vMrkFx2r5vxCtOOfmjSFj/8q0ypElRTdi9YhQvQV7PoN
         1FwPNu+PGf48VlHNvG6qtCwkfr05+aawtZFy4FG54hmhwFzZrLAuW7shmWetJ7CzSkR9
         AhHQ==
X-Gm-Message-State: AOAM533iGoJL71OwOvfyp+B+R05H2piKMuHWTO0JIJfgC4MiUlmB/ELl
        GXIDJh2sTKAN8PiXAdhCHwTJdA==
X-Google-Smtp-Source: ABdhPJwaToTLmiQjaY3vBf5Es2u/aT4IhHLcVgsMmEjG28ONWy0ceySd3aK+1VxmNZZ2vl+p+YIPww==
X-Received: by 2002:a5d:944a:: with SMTP id x10mr14903565ior.18.1637770226650;
        Wed, 24 Nov 2021 08:10:26 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y8sm137249iox.32.2021.11.24.08.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 08:10:26 -0800 (PST)
Subject: Re: uring regression - lost write request
From:   Jens Axboe <axboe@kernel.dk>
To:     Daniel Black <daniel@mariadb.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
 <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
 <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
 <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
 <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk>
Message-ID: <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk>
Date:   Wed, 24 Nov 2021 09:10:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------808A073775A4081ECB9B4918"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------808A073775A4081ECB9B4918
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 11/24/21 8:28 AM, Jens Axboe wrote:
> On 11/23/21 8:27 PM, Daniel Black wrote:
>> On Mon, Nov 15, 2021 at 7:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 11/14/21 1:33 PM, Daniel Black wrote:
>>>> On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> Alright, give this one a go if you can. Against -git, but will apply to
>>>>> 5.15 as well.
>>>>
>>>>
>>>> Works. Thank you very much.
>>>>
>>>> https://jira.mariadb.org/browse/MDEV-26674?page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel&focusedCommentId=205599#comment-205599
>>>>
>>>> Tested-by: Marko Mäkelä <marko.makela@mariadb.com>
>>>
>>> The patch is already upstream (and in the 5.15 stable queue), and I
>>> provided 5.14 patches too.
>>
>> Jens,
>>
>> I'm getting the same reproducer on 5.14.20
>> (https://bugzilla.redhat.com/show_bug.cgi?id=2018882#c3) though the
>> backport change logs indicate 5.14.19 has the patch.
>>
>> Anything missing?
> 
> We might also need another patch that isn't in stable, I'm attaching
> it here. Any chance you can run 5.14.20/21 with this applied? If not,
> I'll do some sanity checking here and push it to -stable.

Looks good to me - Greg, would you mind queueing this up for
5.14-stable?

-- 
Jens Axboe


--------------808A073775A4081ECB9B4918
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io-wq-split-bounded-and-unbounded-work-into-separate.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io-wq-split-bounded-and-unbounded-work-into-separate.pa";
 filename*1="tch"

From 99e6a29dbda79e5e050be1ffd38dd36622f61af5 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 24 Nov 2021 08:26:11 -0700
Subject: [PATCH] io-wq: split bounded and unbounded work into separate lists

commit f95dc207b93da9c88ddbb7741ec3730c6657b88e upstream.

We've got a few issues that all boil down to the fact that we have one
list of pending work items, yet two different types of workers to
serve them. This causes some oddities around workers switching type and
even hashed work vs regular work on the same bounded list.

Just separate them out cleanly, similarly to how we already do
accounting of what is running. That provides a clean separation and
removes some corner cases that can cause stalls when handling IO
that is punted to io-wq.

Fixes: ecc53c48c13d ("io-wq: check max_worker limits if a worker transitions bound state")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 156 +++++++++++++++++++++++------------------------------
 1 file changed, 68 insertions(+), 88 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0890d85ba285..7d63299b4776 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -32,7 +32,7 @@ enum {
 };
 
 enum {
-	IO_WQE_FLAG_STALLED	= 1,	/* stalled on hash */
+	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
 /*
@@ -71,25 +71,24 @@ struct io_wqe_acct {
 	unsigned max_workers;
 	int index;
 	atomic_t nr_running;
+	struct io_wq_work_list work_list;
+	unsigned long flags;
 };
 
 enum {
 	IO_WQ_ACCT_BOUND,
 	IO_WQ_ACCT_UNBOUND,
+	IO_WQ_ACCT_NR,
 };
 
 /*
  * Per-node worker thread pool
  */
 struct io_wqe {
-	struct {
-		raw_spinlock_t lock;
-		struct io_wq_work_list work_list;
-		unsigned flags;
-	} ____cacheline_aligned_in_smp;
+	raw_spinlock_t lock;
+	struct io_wqe_acct acct[2];
 
 	int node;
-	struct io_wqe_acct acct[2];
 
 	struct hlist_nulls_head free_list;
 	struct list_head all_list;
@@ -195,11 +194,10 @@ static void io_worker_exit(struct io_worker *worker)
 	do_exit(0);
 }
 
-static inline bool io_wqe_run_queue(struct io_wqe *wqe)
-	__must_hold(wqe->lock)
+static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
 {
-	if (!wq_list_empty(&wqe->work_list) &&
-	    !(wqe->flags & IO_WQE_FLAG_STALLED))
+	if (!wq_list_empty(&acct->work_list) &&
+	    !test_bit(IO_ACCT_STALLED_BIT, &acct->flags))
 		return true;
 	return false;
 }
@@ -208,7 +206,8 @@ static inline bool io_wqe_run_queue(struct io_wqe *wqe)
  * Check head of free list for an available worker. If one isn't available,
  * caller must create one.
  */
-static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
+static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
+					struct io_wqe_acct *acct)
 	__must_hold(RCU)
 {
 	struct hlist_nulls_node *n;
@@ -222,6 +221,10 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
 		if (!io_worker_get(worker))
 			continue;
+		if (io_wqe_get_acct(worker) != acct) {
+			io_worker_release(worker);
+			continue;
+		}
 		if (wake_up_process(worker->task)) {
 			io_worker_release(worker);
 			return true;
@@ -340,7 +343,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 
-	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe)) {
+	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
 		io_queue_worker_create(wqe, worker, acct);
@@ -355,29 +358,10 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			     struct io_wq_work *work)
 	__must_hold(wqe->lock)
 {
-	bool worker_bound, work_bound;
-
-	BUILD_BUG_ON((IO_WQ_ACCT_UNBOUND ^ IO_WQ_ACCT_BOUND) != 1);
-
 	if (worker->flags & IO_WORKER_F_FREE) {
 		worker->flags &= ~IO_WORKER_F_FREE;
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
 	}
-
-	/*
-	 * If worker is moving from bound to unbound (or vice versa), then
-	 * ensure we update the running accounting.
-	 */
-	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
-	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
-	if (worker_bound != work_bound) {
-		int index = work_bound ? IO_WQ_ACCT_UNBOUND : IO_WQ_ACCT_BOUND;
-		io_wqe_dec_running(worker);
-		worker->flags ^= IO_WORKER_F_BOUND;
-		wqe->acct[index].nr_workers--;
-		wqe->acct[index ^ 1].nr_workers++;
-		io_wqe_inc_running(worker);
-	 }
 }
 
 /*
@@ -419,44 +403,23 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	return ret;
 }
 
-/*
- * We can always run the work if the worker is currently the same type as
- * the work (eg both are bound, or both are unbound). If they are not the
- * same, only allow it if incrementing the worker count would be allowed.
- */
-static bool io_worker_can_run_work(struct io_worker *worker,
-				   struct io_wq_work *work)
-{
-	struct io_wqe_acct *acct;
-
-	if (!(worker->flags & IO_WORKER_F_BOUND) !=
-	    !(work->flags & IO_WQ_WORK_UNBOUND))
-		return true;
-
-	/* not the same type, check if we'd go over the limit */
-	acct = io_work_get_acct(worker->wqe, work);
-	return acct->nr_workers < acct->max_workers;
-}
-
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 					   struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work, *tail;
 	unsigned int stall_hash = -1U;
+	struct io_wqe *wqe = worker->wqe;
 
-	wq_list_for_each(node, prev, &wqe->work_list) {
+	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
 		work = container_of(node, struct io_wq_work, list);
 
-		if (!io_worker_can_run_work(worker, work))
-			break;
-
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
-			wq_list_del(&wqe->work_list, node, prev);
+			wq_list_del(&acct->work_list, node, prev);
 			return work;
 		}
 
@@ -467,7 +430,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 		/* hashed, can run if not already running */
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
-			wq_list_cut(&wqe->work_list, &tail->list, prev);
+			wq_list_cut(&acct->work_list, &tail->list, prev);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -483,12 +446,12 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
-		wqe->flags |= IO_WQE_FLAG_STALLED;
+		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 		raw_spin_unlock(&wqe->lock);
 		unstalled = io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
 		if (unstalled) {
-			wqe->flags &= ~IO_WQE_FLAG_STALLED;
+			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 			if (wq_has_sleeper(&wqe->wq->hash->wait))
 				wake_up(&wqe->wq->hash->wait);
 		}
@@ -525,6 +488,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
@@ -539,7 +503,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe, worker);
+		work = io_get_next_work(acct, worker);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 
@@ -575,7 +539,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 				/* serialize hash clear with wake_up() */
 				spin_lock_irq(&wq->hash->wait.lock);
 				clear_bit(hash, &wq->hash->map);
-				wqe->flags &= ~IO_WQE_FLAG_STALLED;
+				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 				spin_unlock_irq(&wq->hash->wait.lock);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
@@ -594,6 +558,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	char buf[TASK_COMM_LEN];
@@ -609,7 +574,7 @@ static int io_wqe_worker(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
 		raw_spin_lock_irq(&wqe->lock);
-		if (io_wqe_run_queue(wqe)) {
+		if (io_acct_run_queue(acct)) {
 			io_worker_handle_work(worker);
 			goto loop;
 		}
@@ -777,12 +742,13 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 
 static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 {
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
 	if (!io_wq_is_hashed(work)) {
 append:
-		wq_list_add_tail(&work->list, &wqe->work_list);
+		wq_list_add_tail(&work->list, &acct->work_list);
 		return;
 	}
 
@@ -792,7 +758,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	if (!tail)
 		goto append;
 
-	wq_list_add_after(&work->list, &tail->list, &wqe->work_list);
+	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
 }
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
@@ -814,10 +780,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
-	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 
 	rcu_read_lock();
-	do_create = !io_wqe_activate_free_worker(wqe);
+	do_create = !io_wqe_activate_free_worker(wqe, acct);
 	rcu_read_unlock();
 
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
@@ -870,6 +836,7 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 					 struct io_wq_work *work,
 					 struct io_wq_work_node *prev)
 {
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -881,7 +848,7 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 		else
 			wqe->hash_tail[hash] = NULL;
 	}
-	wq_list_del(&wqe->work_list, &work->list, prev);
+	wq_list_del(&acct->work_list, &work->list, prev);
 }
 
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
@@ -890,22 +857,27 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 	unsigned long flags;
+	int i;
 
 retry:
 	raw_spin_lock_irqsave(&wqe->lock, flags);
-	wq_list_for_each(node, prev, &wqe->work_list) {
-		work = container_of(node, struct io_wq_work, list);
-		if (!match->fn(work, match->data))
-			continue;
-		io_wqe_remove_pending(wqe, work, prev);
-		raw_spin_unlock_irqrestore(&wqe->lock, flags);
-		io_run_cancel(work, wqe);
-		match->nr_pending++;
-		if (!match->cancel_all)
-			return;
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
-		/* not safe to continue after unlock */
-		goto retry;
+		wq_list_for_each(node, prev, &acct->work_list) {
+			work = container_of(node, struct io_wq_work, list);
+			if (!match->fn(work, match->data))
+				continue;
+			io_wqe_remove_pending(wqe, work, prev);
+			raw_spin_unlock_irqrestore(&wqe->lock, flags);
+			io_run_cancel(work, wqe);
+			match->nr_pending++;
+			if (!match->cancel_all)
+				return;
+
+			/* not safe to continue after unlock */
+			goto retry;
+		}
 	}
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 }
@@ -966,18 +938,24 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 			    int sync, void *key)
 {
 	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
+	int i;
 
 	list_del_init(&wait->entry);
 
 	rcu_read_lock();
-	io_wqe_activate_free_worker(wqe);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = &wqe->acct[i];
+
+		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
+			io_wqe_activate_free_worker(wqe, acct);
+	}
 	rcu_read_unlock();
 	return 1;
 }
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
-	int ret, node;
+	int ret, node, i;
 	struct io_wq *wq;
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
@@ -1012,18 +990,20 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
 		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
-		wqe->acct[IO_WQ_ACCT_BOUND].index = IO_WQ_ACCT_BOUND;
-		wqe->acct[IO_WQ_ACCT_UNBOUND].index = IO_WQ_ACCT_UNBOUND;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
-		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 					task_rlimit(current, RLIMIT_NPROC);
-		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
-		wqe->wait.func = io_wqe_hash_wake;
 		INIT_LIST_HEAD(&wqe->wait.entry);
+		wqe->wait.func = io_wqe_hash_wake;
+		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+			struct io_wqe_acct *acct = &wqe->acct[i];
+
+			acct->index = i;
+			atomic_set(&acct->nr_running, 0);
+			INIT_WQ_LIST(&acct->work_list);
+		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
-		INIT_WQ_LIST(&wqe->work_list);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);
 	}
-- 
2.34.0


--------------808A073775A4081ECB9B4918--
