Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0433620621C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392909AbgFWUz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392714AbgFWUpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:45:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD8C21BE5;
        Tue, 23 Jun 2020 20:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945102;
        bh=uAKSTt9G16LBVtwwzGyB3Dma+X5Cueok5yUx4LnhSw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN1Loo52O6d1+GuDBq6PCYBUuj7mSSVlJkuGIYGg5/9H/21iK1F2E+FhkIihQbYam
         yP3qgn+tjRWHBMxjLSKrMjSAfjVsMuJnfRruLUqcDl3wpWu7QGy0I9HKWutfnMEaqb
         z46lJj3XtOCEv7Y71ZynCr6n6ZYxZ/MMTGtFB9OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raghavendra Rao Ananta <rananta@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/136] tty: hvc: Fix data abort due to race in hvc_open
Date:   Tue, 23 Jun 2020 21:58:17 +0200
Message-Id: <20200623195305.714413417@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raghavendra Rao Ananta <rananta@codeaurora.org>

[ Upstream commit e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe ]

Potentially, hvc_open() can be called in parallel when two tasks calls
open() on /dev/hvcX. In such a scenario, if the hp->ops->notifier_add()
callback in the function fails, where it sets the tty->driver_data to
NULL, the parallel hvc_open() can see this NULL and cause a memory abort.
Hence, serialize hvc_open and check if tty->private_data is NULL before
proceeding ahead.

The issue can be easily reproduced by launching two tasks simultaneously
that does nothing but open() and close() on /dev/hvcX.
For example:
$ ./simple_open_close /dev/hvc0 & ./simple_open_close /dev/hvc0 &

Signed-off-by: Raghavendra Rao Ananta <rananta@codeaurora.org>
Link: https://lore.kernel.org/r/20200428032601.22127-1-rananta@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_console.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index d52221ae1b85a..663cbe3669e11 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -88,6 +88,8 @@ static LIST_HEAD(hvc_structs);
  */
 static DEFINE_SPINLOCK(hvc_structs_lock);
 
+/* Mutex to serialize hvc_open */
+static DEFINE_MUTEX(hvc_open_mutex);
 /*
  * This value is used to assign a tty->index value to a hvc_struct based
  * upon order of exposure via hvc_probe(), when we can not match it to
@@ -332,16 +334,24 @@ static int hvc_install(struct tty_driver *driver, struct tty_struct *tty)
  */
 static int hvc_open(struct tty_struct *tty, struct file * filp)
 {
-	struct hvc_struct *hp = tty->driver_data;
+	struct hvc_struct *hp;
 	unsigned long flags;
 	int rc = 0;
 
+	mutex_lock(&hvc_open_mutex);
+
+	hp = tty->driver_data;
+	if (!hp) {
+		rc = -EIO;
+		goto out;
+	}
+
 	spin_lock_irqsave(&hp->port.lock, flags);
 	/* Check and then increment for fast path open. */
 	if (hp->port.count++ > 0) {
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 		hvc_kick();
-		return 0;
+		goto out;
 	} /* else count == 0 */
 	spin_unlock_irqrestore(&hp->port.lock, flags);
 
@@ -369,6 +379,8 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	/* Force wakeup of the polling thread */
 	hvc_kick();
 
+out:
+	mutex_unlock(&hvc_open_mutex);
 	return rc;
 }
 
-- 
2.25.1



