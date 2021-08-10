Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0EA3E821E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhHJSFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236398AbhHJSD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D54610E9;
        Tue, 10 Aug 2021 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617693;
        bh=qpctlMyiO1XTEcesBDxi2L6+Kw433GtzCY8rP37efa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYmn9ygzzhnP5wUUMCqOQKEbK4BCOf74X4WlYOIoXth9sAca7fRM2tOh1cthHwi2C
         /NgTmxqun3cgTyYVv9NlRanq7JKCm9Eph8FclH9Prs4f/X2m2OskEqWZWCDvWNdkbs
         a5HFaj9bHk4+bCB7XoTv4CyfWUOiGFxXmSfs3XR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 138/175] scsi: ibmvfc: Fix command state accounting and stale response detection
Date:   Tue, 10 Aug 2021 19:30:46 +0200
Message-Id: <20210810173005.487780743@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

commit a264cf5e81c78e2b9918b8b9ef2ace9dde1850df upstream.

Prior to commit 1f4a4a19508d ("scsi: ibmvfc: Complete commands outside the
host/queue lock") responses to commands were completed sequentially with
the host lock held such that a command had a basic binary state of active
or free. It was therefore a simple affair of ensuring the assocaiated
ibmvfc_event to a VIOS response was valid by testing that it was not
already free. The lock relexation work to complete commands outside the
lock inadverdently made it a trinary command state such that a command is
either in flight, received and being completed, or completed and now
free. This breaks the stale command detection logic as a command may be
still marked active and been placed on the delayed completion list when a
second stale response for the same command arrives. This can lead to double
completions and list corruption. This issue was exposed by a recent VIOS
regression were a missing memory barrier could occasionally result in the
ibmvfc client receiving a duplicate response for the same command.

Fix the issue by introducing the atomic ibmvfc_event.active to track the
trinary state of a command. The state is explicitly set to 1 when a command
is successfully sent. The CRQ response handlers use
atomic_dec_if_positive() to test for stale responses and correctly
transition to the completion state when a active command is received.
Finally, atomic_dec_and_test() is used to sanity check transistions when
commands are freed as a result of a completion, or moved to the purge list
as a result of error handling or adapter reset.

Link: https://lore.kernel.org/r/20210716205220.1101150-1-tyreld@linux.ibm.com
Fixes: 1f4a4a19508d ("scsi: ibmvfc: Complete commands outside the host/queue lock")
Cc: stable@vger.kernel.org
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   19 +++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -804,6 +804,13 @@ static int ibmvfc_init_event_pool(struct
 	for (i = 0; i < size; ++i) {
 		struct ibmvfc_event *evt = &pool->events[i];
 
+		/*
+		 * evt->active states
+		 *  1 = in flight
+		 *  0 = being completed
+		 * -1 = free/freed
+		 */
+		atomic_set(&evt->active, -1);
 		atomic_set(&evt->free, 1);
 		evt->crq.valid = 0x80;
 		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
@@ -1014,6 +1021,7 @@ static void ibmvfc_free_event(struct ibm
 
 	BUG_ON(!ibmvfc_valid_event(pool, evt));
 	BUG_ON(atomic_inc_return(&evt->free) != 1);
+	BUG_ON(atomic_dec_and_test(&evt->active));
 
 	spin_lock_irqsave(&evt->queue->l_lock, flags);
 	list_add_tail(&evt->queue_list, &evt->queue->free);
@@ -1069,6 +1077,12 @@ static void ibmvfc_complete_purge(struct
  **/
 static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 {
+	/*
+	 * Anything we are failing should still be active. Otherwise, it
+	 * implies we already got a response for the command and are doing
+	 * something bad like double completing it.
+	 */
+	BUG_ON(!atomic_dec_and_test(&evt->active));
 	if (evt->cmnd) {
 		evt->cmnd->result = (error_code << 16);
 		evt->done = ibmvfc_scsi_eh_done;
@@ -1720,6 +1734,7 @@ static int ibmvfc_send_event(struct ibmv
 
 		evt->done(evt);
 	} else {
+		atomic_set(&evt->active, 1);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
 	}
@@ -3248,7 +3263,7 @@ static void ibmvfc_handle_crq(struct ibm
 		return;
 	}
 
-	if (unlikely(atomic_read(&evt->free))) {
+	if (unlikely(atomic_dec_if_positive(&evt->active))) {
 		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
 			crq->ioba);
 		return;
@@ -3775,7 +3790,7 @@ static void ibmvfc_handle_scrq(struct ib
 		return;
 	}
 
-	if (unlikely(atomic_read(&evt->free))) {
+	if (unlikely(atomic_dec_if_positive(&evt->active))) {
 		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
 			crq->ioba);
 		return;
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -744,6 +744,7 @@ struct ibmvfc_event {
 	struct ibmvfc_target *tgt;
 	struct scsi_cmnd *cmnd;
 	atomic_t free;
+	atomic_t active;
 	union ibmvfc_iu *xfer_iu;
 	void (*done)(struct ibmvfc_event *evt);
 	void (*_done)(struct ibmvfc_event *evt);


