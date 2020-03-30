Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B131197F4F
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgC3POB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 11:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgC3POB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 11:14:01 -0400
Received: from localhost.localdomain (host109-155-186-24.range109-155.btcentralplus.com [109.155.186.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636D0206F5;
        Mon, 30 Mar 2020 15:14:00 +0000 (UTC)
From:   Anton Altaparmakov <anton@tuxera.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org,
        Anton Altaparmakov <anton@tuxera.com>, stable@vger.kernel.org
Subject: [PATCH] Remove bogus warning in __mark_inode_dirty().
Date:   Mon, 30 Mar 2020 16:13:54 +0100
Message-Id: <20200330151354.16648-1-anton@tuxera.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The warning about "bdi-%s not registered" in __mark_inode_dirty()
is incorrect and can relatively easily be triggered during failsafe
testing of any file system where the test involves unplugging the
storage without unmounting in the middle of write operations.

Even if the filesystem checks "is device not unplugged" before calling
__mark_inode_dirty() the device unplug can happen after this check has
been performed but before __mark_inode_dirty() gets to the check inside
the WARN().

Thus this patch simply removes this warning as it is perfectly normal
thing to happen when volume is unplugged whilst being written to.

Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
Cc: stable@vger.kernel.org
---
 fs/fs-writeback.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 76ac9c7d32ec..443134d3dbf3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2318,10 +2318,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 
 			wb = locked_inode_to_wb_and_lock_list(inode);
 
-			WARN(bdi_cap_writeback_dirty(wb->bdi) &&
-			     !test_bit(WB_registered, &wb->state),
-			     "bdi-%s not registered\n", wb->bdi->name);
-
 			inode->dirtied_when = jiffies;
 			if (dirtytime)
 				inode->dirtied_time_when = jiffies;
-- 
2.24.1 (Apple Git-126)

