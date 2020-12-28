Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6912E37D4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgL1NBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgL1NAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E79E22B2A;
        Mon, 28 Dec 2020 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160385;
        bh=SGlegLTLtGNir0urkvQvD8y2E5Ey3+y4+dIcD55sGMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQD0qbxJzHxfUP9JB4C5O/U8ZJNvzTDc7VwupLmtckU0aN54z49QB1LfXp1YBhE7Z
         KiUX/XRFp4iJYxyvAvTJU4rC+dpv5N9WONaYc3CHo26sz3ErHT3OPA82U1P4mlBlld
         Ye5jAb6npwCQAX4skz0ndW/1FJudKUonHJakbu6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 034/175] dm table: Remove BUG_ON(in_interrupt())
Date:   Mon, 28 Dec 2020 13:48:07 +0100
Message-Id: <20201228124854.909417576@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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



