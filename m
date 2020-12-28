Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B452D2E3885
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgL1NLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731617AbgL1NLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F11B520728;
        Mon, 28 Dec 2020 13:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161033;
        bh=nMf3gnOx6eJxxED5MzzNT844IXb6sTEqjQRbZaVsyUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF4rKMx2gs7Eq55bVKYcGiUg/1gGgRNTrozKBjnRaRvaq9DCT59yzKgFMQ6aFH9pA
         zzb56glHHe79PNyOrk7cKE7dt5QuOl2cFyI6Dhw+6MLG/yDy4bEpTzpg/hbFJ9XJhA
         5yNvrYwqjgAE3mDpRCUpszoql/jZ5xI+rWMw7gh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 047/242] dm table: Remove BUG_ON(in_interrupt())
Date:   Mon, 28 Dec 2020 13:47:32 +0100
Message-Id: <20201228124906.996140747@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 777343cff5f1e..78d4e7347e2f3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1295,12 +1295,6 @@ void dm_table_event_callback(struct dm_table *t,
 
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



