Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE192E663C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388552AbgL1QKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388513AbgL1NXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32815207C9;
        Mon, 28 Dec 2020 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161772;
        bh=MjM1C2S8hy4o3teJH+kaPWf6nPImpZwMYpp/5Kwj5kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4QsuOH10KZWCJOMZRuFu7UxFMWOOQhEj4fPG23rBB4A4mCxXvmYJo3+SzpwTrGlv
         g5XiGmmuuLVkWKHY23bUtTzzSb5r6W3wfUV61absRjHhBLtTZ77kuIBTLnaj5jxFS2
         SDX/SVaWvc7jE9nDJWkITvliOglmMw98psXtIH/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/346] dm table: Remove BUG_ON(in_interrupt())
Date:   Mon, 28 Dec 2020 13:46:35 +0100
Message-Id: <20201228124923.470192404@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 36275c59e4e7b..f849db3035a05 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1336,12 +1336,6 @@ void dm_table_event_callback(struct dm_table *t,
 
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



