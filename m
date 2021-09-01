Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F39D3FDB81
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344348AbhIAMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345006AbhIAMkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 946BC6108E;
        Wed,  1 Sep 2021 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499793;
        bh=OeXOECg83tGksMwCNTdERexJ1xATeYk2A0Su0X60Jns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6iiMm/x6l3A1jSgYf5wuqVh/L437y/5TJZgkbRKj4t3WGL76Z1lCOHpV995QQ2k4
         e0V6N/Y6CTg/sEExySsJQ8N01qjdrtDIUSkoLjcr9dbou2FtH0G++9tRwgpTDSi0Kw
         u3Yu4rivlRskZyTEM1lorrdCj/qEg1nPrO6QMIUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 088/103] srcu: Provide internal interface to start a Tiny SRCU grace period
Date:   Wed,  1 Sep 2021 14:28:38 +0200
Message-Id: <20210901122303.496935499@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 1a893c711a600ab57526619b56e6f6b7be00956e upstream.

There is a need for a polling interface for SRCU grace periods.
This polling needs to initiate an SRCU grace period without
having to queue (and manage) a callback.  This commit therefore
splits the Tiny SRCU call_srcu() function into callback-queuing and
start-grace-period portions, with the latter in a new function named
srcu_gp_start_if_needed().

Link: https://lore.kernel.org/rcu/20201112201547.GF3365678@moria.home.lan/
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/srcutiny.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -151,6 +151,16 @@ void srcu_drive_gp(struct work_struct *w
 }
 EXPORT_SYMBOL_GPL(srcu_drive_gp);
 
+static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
+{
+	if (!READ_ONCE(ssp->srcu_gp_running)) {
+		if (likely(srcu_init_done))
+			schedule_work(&ssp->srcu_work);
+		else if (list_empty(&ssp->srcu_work.entry))
+			list_add(&ssp->srcu_work.entry, &srcu_boot_list);
+	}
+}
+
 /*
  * Enqueue an SRCU callback on the specified srcu_struct structure,
  * initiating grace-period processing if it is not already running.
@@ -166,12 +176,7 @@ void call_srcu(struct srcu_struct *ssp,
 	*ssp->srcu_cb_tail = rhp;
 	ssp->srcu_cb_tail = &rhp->next;
 	local_irq_restore(flags);
-	if (!READ_ONCE(ssp->srcu_gp_running)) {
-		if (likely(srcu_init_done))
-			schedule_work(&ssp->srcu_work);
-		else if (list_empty(&ssp->srcu_work.entry))
-			list_add(&ssp->srcu_work.entry, &srcu_boot_list);
-	}
+	srcu_gp_start_if_needed(ssp);
 }
 EXPORT_SYMBOL_GPL(call_srcu);
 


