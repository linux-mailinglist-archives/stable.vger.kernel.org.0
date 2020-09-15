Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B28526B423
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgIOXRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0499B224BD;
        Tue, 15 Sep 2020 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180156;
        bh=58TBYymxmKpaFYpk4lNiLPMkNeK6ZLrqqxeFmqXRauY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZxGYz7h6vNKINk8KdYkmiDNtX+lUiCvwxnYa3pmb5AXlUJlK8PXSG2vgjnatvE9Q
         XRngvsfhALGcxldKMEmYIoJz9zJHrgqSjjiLK+lSIqhMBZEbnyUXVlCFuZzNdSdOwS
         DEh6UG4r8spOflL3skJCTyafKaND1DYo5vi62o4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        "Nikunj A. Dadhania" <nikunj.dadhania@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.8 131/177] thunderbolt: Disable ports that are not implemented
Date:   Tue, 15 Sep 2020 16:13:22 +0200
Message-Id: <20200915140659.930599375@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikunj A. Dadhania <nikunj.dadhania@linux.intel.com>

commit 8824d19b45867be75d375385414c4f06719a11a4 upstream.

Commit 4caf2511ec49 ("thunderbolt: Add trivial .shutdown") exposes a bug
in the Thunderbolt driver, that frees an unallocated id, resulting in the
following spinlock bad magic bug.

[ 20.633803] BUG: spinlock bad magic on CPU#4, halt/3313
[ 20.640030] lock: 0xffff92e6ad5c97e0, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[ 20.672139] Call Trace:
[ 20.675032] dump_stack+0x97/0xdb
[ 20.678950] ? spin_bug+0xa5/0xb0
[ 20.682865] do_raw_spin_lock+0x68/0x98
[ 20.687397] _raw_spin_lock_irqsave+0x3f/0x5d
[ 20.692535] ida_destroy+0x4f/0x124
[ 20.696657] tb_switch_release+0x6d/0xfd
[ 20.701295] device_release+0x2c/0x7d
[ 20.705622] kobject_put+0x8e/0xac
[ 20.709637] tb_stop+0x55/0x66
[ 20.713243] tb_domain_remove+0x36/0x62
[ 20.717774] nhi_remove+0x4d/0x58

Fix the issue by disabling ports that are enabled as per the EEPROM, but
not implemented. While at it, update the kernel doc for the disabled
field, to reflect this.

Cc: stable@vger.kernel.org
Fixes: 4caf2511ec49 ("thunderbolt: Add trivial .shutdown")
Reported-by: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
Signed-off-by: Nikunj A. Dadhania <nikunj.dadhania@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/switch.c |    1 +
 drivers/thunderbolt/tb.h     |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -739,6 +739,7 @@ static int tb_init_port(struct tb_port *
 		if (res == -ENODEV) {
 			tb_dbg(port->sw->tb, " Port %d: not implemented\n",
 			       port->port);
+			port->disabled = true;
 			return 0;
 		}
 		return res;
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -167,7 +167,7 @@ struct tb_switch {
  * @cap_adap: Offset of the adapter specific capability (%0 if not present)
  * @cap_usb4: Offset to the USB4 port capability (%0 if not present)
  * @port: Port number on switch
- * @disabled: Disabled by eeprom
+ * @disabled: Disabled by eeprom or enabled but not implemented
  * @bonded: true if the port is bonded (two lanes combined as one)
  * @dual_link_port: If the switch is connected using two ports, points
  *		    to the other port.


