Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBC634417F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhCVMdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230290AbhCVMdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3ED619A8;
        Mon, 22 Mar 2021 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416380;
        bh=VdBJmZUaLe0VaDm377AThMdHYlmhbxsnqxyu+AZpJhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poqPUtHnARdFHxLPRCFj7zavvXBm3ZuNVla2OopYCJBZXv9tLZ6RLJlgg3YtAq6Jk
         8XHDu/AUPad87DJBszg3dg6TKHOJ2YPKUZJRlRfDG1MUfnCIUEXqi0UdBP85l/N42i
         QWzXRlNPt8ewCrBwkct8Ju9QDY5+9tzLmXUzqWIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.11 085/120] thunderbolt: Initialize HopID IDAs in tb_switch_alloc()
Date:   Mon, 22 Mar 2021 13:27:48 +0100
Message-Id: <20210322121932.517724419@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 781e14eaa7d168dc07d2a2eea5c55831a5bb46f3 upstream.

If there is a failure before the tb_switch_add() is called the switch
object is released by tb_switch_release() but at that point HopID IDAs
have not yet been initialized. So we see splat like this:

BUG: spinlock bad magic on CPU#2, kworker/u8:5/115
...
Workqueue: thunderbolt0 tb_handle_hotplug
Call Trace:
 dump_stack+0x97/0xdc
 ? spin_bug+0x9a/0xa7
 do_raw_spin_lock+0x68/0x98
 _raw_spin_lock_irqsave+0x3f/0x5d
 ida_destroy+0x4f/0x127
 tb_switch_release+0x6d/0xfd
 device_release+0x2c/0x7d
 kobject_put+0x9b/0xbc
 tb_handle_hotplug+0x278/0x452
 process_one_work+0x1db/0x396
 worker_thread+0x216/0x375
 kthread+0x14d/0x155
 ? pr_cont_work+0x58/0x58
 ? kthread_blkcg+0x2e/0x2e
 ret_from_fork+0x1f/0x40

Fix this by always initializing HopID IDAs in tb_switch_alloc().

Fixes: 0b2863ac3cfd ("thunderbolt: Add functions for allocating and releasing HopIDs")
Cc: stable@vger.kernel.org
Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -762,12 +762,6 @@ static int tb_init_port(struct tb_port *
 
 	tb_dump_port(port->sw->tb, &port->config);
 
-	/* Control port does not need HopID allocation */
-	if (port->port) {
-		ida_init(&port->in_hopids);
-		ida_init(&port->out_hopids);
-	}
-
 	INIT_LIST_HEAD(&port->list);
 	return 0;
 
@@ -1789,10 +1783,8 @@ static void tb_switch_release(struct dev
 	dma_port_free(sw->dma_port);
 
 	tb_switch_for_each_port(sw, port) {
-		if (!port->disabled) {
-			ida_destroy(&port->in_hopids);
-			ida_destroy(&port->out_hopids);
-		}
+		ida_destroy(&port->in_hopids);
+		ida_destroy(&port->out_hopids);
 	}
 
 	kfree(sw->uuid);
@@ -1972,6 +1964,12 @@ struct tb_switch *tb_switch_alloc(struct
 		/* minimum setup for tb_find_cap and tb_drom_read to work */
 		sw->ports[i].sw = sw;
 		sw->ports[i].port = i;
+
+		/* Control port does not need HopID allocation */
+		if (i) {
+			ida_init(&sw->ports[i].in_hopids);
+			ida_init(&sw->ports[i].out_hopids);
+		}
 	}
 
 	ret = tb_switch_find_vse_cap(sw, TB_VSE_CAP_PLUG_EVENTS);


