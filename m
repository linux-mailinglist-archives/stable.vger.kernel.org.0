Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3792191FB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfEIStt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfEISts (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:49:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C837217F9;
        Thu,  9 May 2019 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427787;
        bh=zEkpSKpNxQ9eAA+mpyxf27JasOOiBzYr8WawKE5QZOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUIDpJqlRDCd/dOiRIWP0/NPpcyvPgvIw79YfFGiL9qAFE+firaNrn+Yurjohivyg
         xsaGe5DhmuKIid7JrAU8KsRTFe3oormP0TG9z2IB0RGQBrIz3VEgJyn+9h9oU0XONe
         sO0+LVrQtyTQJyI+5aJ68zjrJty3wND2+1iqbmqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Sodagudi <psodagud@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>, marc.zyngier@arm.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/66] genirq: Prevent use-after-free and work list corruption
Date:   Thu,  9 May 2019 20:42:25 +0200
Message-Id: <20190509181306.946889313@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 59c39840f5abf4a71e1810a8da71aaccd6c17d26 ]

When irq_set_affinity_notifier() replaces the notifier, then the
reference count on the old notifier is dropped which causes it to be
freed. But nothing ensures that the old notifier is not longer queued
in the work list. If it is queued this results in a use after free and
possibly in work list corruption.

Ensure that the work is canceled before the reference is dropped.

Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: marc.zyngier@arm.com
Link: https://lkml.kernel.org/r/1553439424-6529-1-git-send-email-psodagud@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/manage.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5c0ba5ca59308..cd4f9f3e8345c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -356,8 +356,10 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 	desc->affinity_notify = notify;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	if (old_notify)
+	if (old_notify) {
+		cancel_work_sync(&old_notify->work);
 		kref_put(&old_notify->kref, old_notify->release);
+	}
 
 	return 0;
 }
-- 
2.20.1



