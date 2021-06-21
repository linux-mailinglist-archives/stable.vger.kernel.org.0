Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5CC3AF084
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhFUQuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhFUQrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F0C61411;
        Mon, 21 Jun 2021 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293206;
        bh=+kw6gacuD5MpMIJNQY2MyzuE7L6CZv/U0LPHVX2OrnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bItvNPhzE+HV3KcUiHDaO7cgKleloAj6LXZBpODbXFkwZIagf89z1kRvwaA1EL2/j
         kPjxtbuhFYTLZLVtF06o47htElE/5QTdE+u0MIdHavx6XPzYf+ctpH0k890aF0oH44
         Ss8ezmoZItyO42fvXhwBZe0UmirDfoiKMAMx/amU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.12 138/178] s390/ap: Fix hanging ioctl caused by wrong msg counter
Date:   Mon, 21 Jun 2021 18:15:52 +0200
Message-Id: <20210621154927.470081409@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit e73a99f3287a740a07d6618e9470f4d6cb217da8 upstream.

When a AP queue is switched to soft offline, all pending
requests are purged out of the pending requests list and
'received' by the upper layer like zcrypt device drivers.
This is also done for requests which are already enqueued
into the firmware queue. A request in a firmware queue
may eventually produce an response message, but there is
no waiting process any more. However, the response was
counted with the queue_counter and as this counter was
reset to 0 with the offline switch, the pending response
caused the queue_counter to get negative. The next request
increased this counter to 0 (instead of 1) which caused
the ap code to assume there is nothing to receive and so
the response for this valid request was never tried to
fetch from the firmware queue.

This all caused a queue to not work properly after a
switch offline/online and in the end processes to hang
forever when trying to send a crypto request after an
queue offline/online switch cicle.

Fixed by a) making sure the counter does not drop below 0
and b) on a successful enqueue of a message has at least
a value of 1.

Additionally a warning is emitted, when a reply can't get
assigned to a waiting process. This may be normal operation
(process had timeout or has been killed) but may give a
hint that something unexpected happened (like this odd
behavior described above).

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/ap_queue.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -135,12 +135,13 @@ static struct ap_queue_status ap_sm_recv
 {
 	struct ap_queue_status status;
 	struct ap_message *ap_msg;
+	bool found = false;
 
 	status = ap_dqap(aq->qid, &aq->reply->psmid,
 			 aq->reply->msg, aq->reply->len);
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
-		aq->queue_count--;
+		aq->queue_count = max_t(int, 0, aq->queue_count - 1);
 		if (aq->queue_count > 0)
 			mod_timer(&aq->timeout,
 				  jiffies + aq->request_timeout);
@@ -150,8 +151,14 @@ static struct ap_queue_status ap_sm_recv
 			list_del_init(&ap_msg->list);
 			aq->pendingq_count--;
 			ap_msg->receive(aq, ap_msg, aq->reply);
+			found = true;
 			break;
 		}
+		if (!found) {
+			AP_DBF_WARN("%s unassociated reply psmid=0x%016llx on 0x%02x.%04x\n",
+				    __func__, aq->reply->psmid,
+				    AP_QID_CARD(aq->qid), AP_QID_QUEUE(aq->qid));
+		}
 		fallthrough;
 	case AP_RESPONSE_NO_PENDING_REPLY:
 		if (!status.queue_empty || aq->queue_count <= 0)
@@ -232,7 +239,7 @@ static enum ap_sm_wait ap_sm_write(struc
 			   ap_msg->flags & AP_MSG_FLAG_SPECIAL);
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
-		aq->queue_count++;
+		aq->queue_count = max_t(int, 1, aq->queue_count + 1);
 		if (aq->queue_count == 1)
 			mod_timer(&aq->timeout, jiffies + aq->request_timeout);
 		list_move_tail(&ap_msg->list, &aq->pendingq);


