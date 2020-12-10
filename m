Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC522D6033
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391325AbgLJPoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391247AbgLJOjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:52 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paulian Bogdan Marinca <paulian@marinca.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.9 33/75] thunderbolt: Fix use-after-free in remove_unplugged_switch()
Date:   Thu, 10 Dec 2020 15:26:58 +0100
Message-Id: <20201210142607.691475078@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 600c0849cf86b75d86352f59745226273290986a upstream.

Paulian reported a crash that happens when a dock is unplugged during
hibernation:

[78436.228217] thunderbolt 0-1: device disconnected
[78436.228365] BUG: kernel NULL pointer dereference, address: 00000000000001e0
...
[78436.228397] RIP: 0010:icm_free_unplugged_children+0x109/0x1a0
...
[78436.228432] Call Trace:
[78436.228439]  icm_rescan_work+0x24/0x30
[78436.228444]  process_one_work+0x1a3/0x3a0
[78436.228449]  worker_thread+0x30/0x370
[78436.228454]  ? process_one_work+0x3a0/0x3a0
[78436.228457]  kthread+0x13d/0x160
[78436.228461]  ? kthread_park+0x90/0x90
[78436.228465]  ret_from_fork+0x1f/0x30

This happens because remove_unplugged_switch() calls tb_switch_remove()
that releases the memory pointed by sw so the following lines reference
to a memory that might be released already.

Fix this by saving pointer to the parent device before calling
tb_switch_remove().

Reported-by: Paulian Bogdan Marinca <paulian@marinca.net>
Fixes: 4f7c2e0d8765 ("thunderbolt: Make sure device runtime resume completes before taking domain lock")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/icm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -1973,7 +1973,9 @@ static int complete_rpm(struct device *d
 
 static void remove_unplugged_switch(struct tb_switch *sw)
 {
-	pm_runtime_get_sync(sw->dev.parent);
+	struct device *parent = get_device(sw->dev.parent);
+
+	pm_runtime_get_sync(parent);
 
 	/*
 	 * Signal this and switches below for rpm_complete because
@@ -1984,8 +1986,10 @@ static void remove_unplugged_switch(stru
 	bus_for_each_dev(&tb_bus_type, &sw->dev, NULL, complete_rpm);
 	tb_switch_remove(sw);
 
-	pm_runtime_mark_last_busy(sw->dev.parent);
-	pm_runtime_put_autosuspend(sw->dev.parent);
+	pm_runtime_mark_last_busy(parent);
+	pm_runtime_put_autosuspend(parent);
+
+	put_device(parent);
 }
 
 static void icm_free_unplugged_children(struct tb_switch *sw)


