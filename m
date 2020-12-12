Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C746B2D87EF
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439569AbgLLQV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439498AbgLLQKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:50 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/5] dm table: Remove BUG_ON(in_interrupt())
Date:   Sat, 12 Dec 2020 11:09:09 -0500
Message-Id: <20201212160910.2335511-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160910.2335511-1-sashal@kernel.org>
References: <20201212160910.2335511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit e7b624183d921b49ef0a96329f21647d38865ee9 ]

The BUG_ON(in_interrupt()) in dm_table_event() is a historic leftover from
a rework of the dm table code which changed the calling context.

Issuing a BUG for a wrong calling context is frowned upon and
in_interrupt() is deprecated and only covering parts of the wrong
contexts. The sanity check for the context is covered by
CONFIG_DEBUG_ATOMIC_SLEEP and other debug facilities already.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2d3ff028f50c9..62e3dc19b6099 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1250,12 +1250,6 @@ void dm_table_event_callback(struct dm_table *t,
 
 void dm_table_event(struct dm_table *t)
 {
-	/*
-	 * You can no longer call dm_table_event() from interrupt
-	 * context, use a bottom half instead.
-	 */
-	BUG_ON(in_interrupt());
-
 	mutex_lock(&_event_lock);
 	if (t->event_fn)
 		t->event_fn(t->event_context);
-- 
2.27.0

