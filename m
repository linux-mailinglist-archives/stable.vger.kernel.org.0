Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159AE148220
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391364AbgAXLZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391499AbgAXLZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:25:29 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539252075D;
        Fri, 24 Jan 2020 11:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865128;
        bh=WuuGUHllKEaRwTEewQ4s8Vxp9Zxuk3Sxd+JLm9SsTvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZKju/xItapc3lJDGzxe6h6b0jZIsQ2ETOVoXLuu6vW79FUl75BI/Y76iwuK7gw1F
         yb++opzPFSFACTAjxJRBoDYEHfFo26/c83u3vIU+aYpgdZRQnZlNwC/GEPVqnKgSVt
         L4/Pbt57BkdkDGMFppld8hny7PS/g0OQa0VwHIJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 461/639] um: Fix IRQ controller regression on console read
Date:   Fri, 24 Jan 2020 10:30:31 +0100
Message-Id: <20200124093144.965717733@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <j@w1.fi>

[ Upstream commit bebe4681d0e7e1be2608282dc86645728bc7f623 ]

The conversion of UML to use epoll based IRQ controller claimed that
clone_one_chan() can safely call um_free_irq() while starting to ignore
the delay_free_irq parameter that explicitly noted that the IRQ cannot
be freed because this is being called from chan_interrupt(). This
resulted in free_irq() getting called in interrupt context ("Trying to
free IRQ 6 from IRQ context!").

Fix this by restoring previously used delay_free_irq processing.

Fixes: ff6a17989c08 ("Epoll based IRQ controller")
Signed-off-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/chan_kern.c | 52 +++++++++++++++++++++++++++++++------
 arch/um/kernel/irq.c        |  4 +++
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 05588f9466c7f..13ba195f9c9c8 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -171,19 +171,55 @@ int enable_chan(struct line *line)
 	return err;
 }
 
+/* Items are added in IRQ context, when free_irq can't be called, and
+ * removed in process context, when it can.
+ * This handles interrupt sources which disappear, and which need to
+ * be permanently disabled.  This is discovered in IRQ context, but
+ * the freeing of the IRQ must be done later.
+ */
+static DEFINE_SPINLOCK(irqs_to_free_lock);
+static LIST_HEAD(irqs_to_free);
+
+void free_irqs(void)
+{
+	struct chan *chan;
+	LIST_HEAD(list);
+	struct list_head *ele;
+	unsigned long flags;
+
+	spin_lock_irqsave(&irqs_to_free_lock, flags);
+	list_splice_init(&irqs_to_free, &list);
+	spin_unlock_irqrestore(&irqs_to_free_lock, flags);
+
+	list_for_each(ele, &list) {
+		chan = list_entry(ele, struct chan, free_list);
+
+		if (chan->input && chan->enabled)
+			um_free_irq(chan->line->driver->read_irq, chan);
+		if (chan->output && chan->enabled)
+			um_free_irq(chan->line->driver->write_irq, chan);
+		chan->enabled = 0;
+	}
+}
+
 static void close_one_chan(struct chan *chan, int delay_free_irq)
 {
+	unsigned long flags;
+
 	if (!chan->opened)
 		return;
 
-    /* we can safely call free now - it will be marked
-     *  as free and freed once the IRQ stopped processing
-     */
-	if (chan->input && chan->enabled)
-		um_free_irq(chan->line->driver->read_irq, chan);
-	if (chan->output && chan->enabled)
-		um_free_irq(chan->line->driver->write_irq, chan);
-	chan->enabled = 0;
+	if (delay_free_irq) {
+		spin_lock_irqsave(&irqs_to_free_lock, flags);
+		list_add(&chan->free_list, &irqs_to_free);
+		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
+	} else {
+		if (chan->input && chan->enabled)
+			um_free_irq(chan->line->driver->read_irq, chan);
+		if (chan->output && chan->enabled)
+			um_free_irq(chan->line->driver->write_irq, chan);
+		chan->enabled = 0;
+	}
 	if (chan->ops->close != NULL)
 		(*chan->ops->close)(chan->fd, chan->data);
 
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 6b7f3827d6e4a..2753718d31b9d 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -21,6 +21,8 @@
 #include <irq_user.h>
 
 
+extern void free_irqs(void);
+
 /* When epoll triggers we do not know why it did so
  * we can also have different IRQs for read and write.
  * This is why we keep a small irq_fd array for each fd -
@@ -100,6 +102,8 @@ void sigio_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
 			}
 		}
 	}
+
+	free_irqs();
 }
 
 static int assign_epoll_events_to_irq(struct irq_entry *irq_entry)
-- 
2.20.1



