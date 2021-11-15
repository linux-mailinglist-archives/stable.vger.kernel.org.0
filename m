Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C54512E4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347548AbhKOTkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245144AbhKOTTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DC24619E1;
        Mon, 15 Nov 2021 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000945;
        bh=LYTfZ56JvZA9gMNvBtrLF+11I2B17jQl9P9Siweu6Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXZTB57BvO7+fAucHA+EilB87GHCGhNi4fvz6YgodEimO/cPJJH9JhgqxLkuy9w6V
         yZSYGFxfgt3cbC7wn1C6o+zG/HgSK0cD8KttZsrQ7NYbuAB9maPJLPJokrZRFYR/jd
         G11iLsJEMnQQvsyilK+x6WZa/Dgh1aGtGset82Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.14 820/849] s390/ap: Fix hanging ioctl caused by orphaned replies
Date:   Mon, 15 Nov 2021 18:05:03 +0100
Message-Id: <20211115165447.969887692@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit 3826350e6dd435e244eb6e47abad5a47c169ebc2 upstream.

When a queue is switched to soft offline during heavy load and later
switched to soft online again and now used, it may be that the caller
is blocked forever in the ioctl call.

The failure occurs because there is a pending reply after the queue(s)
have been switched to offline. This orphaned reply is received when
the queue is switched to online and is accidentally counted for the
outstanding replies. So when there was a valid outstanding reply and
this orphaned reply is received it counts as the outstanding one thus
dropping the outstanding counter to 0. Voila, with this counter the
receive function is not called any more and the real outstanding reply
is never received (until another request comes in...) and the ioctl
blocks.

The fix is simple. However, instead of readjusting the counter when an
orphaned reply is detected, I check the queue status for not empty and
compare this to the outstanding counter. So if the queue is not empty
then the counter must not drop to 0 but at least have a value of 1.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/ap_queue.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -157,6 +157,8 @@ static struct ap_queue_status ap_sm_recv
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		aq->queue_count = max_t(int, 0, aq->queue_count - 1);
+		if (!status.queue_empty && !aq->queue_count)
+			aq->queue_count++;
 		if (aq->queue_count > 0)
 			mod_timer(&aq->timeout,
 				  jiffies + aq->request_timeout);


