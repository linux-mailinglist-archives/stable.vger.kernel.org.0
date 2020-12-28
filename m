Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCDE2E3A98
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391287AbgL1NjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391276AbgL1NjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E6822582;
        Mon, 28 Dec 2020 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162704;
        bh=UZAils1d1ISw3y85mSNJwLZjqWdqUOrAT0KIiE0n4d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KScC1nnHRo8zYvRxN74lBotnaEUr13alrwawUs999yel09EmZyhlBmim7FKw6f9Hx
         c+FqWeTSBO9hzKScL/7sRUBncNnLUss9+tI0rhHXYC7Q72FtCCSbuJv7EGhTBENMoz
         BDLoLagXhCjwqKGZAvt3KHBZMlK2zpUbXwb3CdHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/453] dm table: Remove BUG_ON(in_interrupt())
Date:   Mon, 28 Dec 2020 13:44:41 +0100
Message-Id: <20201228124939.420659906@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 13ad791126618..6dd56afa048c2 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1320,12 +1320,6 @@ void dm_table_event_callback(struct dm_table *t,
 
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



