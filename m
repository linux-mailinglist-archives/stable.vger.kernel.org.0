Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E0C8DAEF
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfHNRJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbfHNRJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 662A8216F4;
        Wed, 14 Aug 2019 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802561;
        bh=H2SNo2hBGn1+a+3W8DhGZHb066COBdcdlba7m9RyHq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oilweuo81prZZDWC4CKScjZGrh337GtaXC43eqaTqZqrk4EpVgH3i8tzePhc9xFlH
         CH58iF2/S2Dmc8RQSe9/b6443fYNx9/kJEZQ0TqijRyjBUd61GRyzz4LqMNPLAXapm
         9oTWGxVC+EJuohVLSB9+FBx6ZgIgvtqnfbHmE3C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Guenter Roeck <linux@roeck-us.net>, Jun Li <jun.li@nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 4.19 29/91] usb: typec: tcpm: Add NULL check before dereferencing config
Date:   Wed, 14 Aug 2019 19:00:52 +0200
Message-Id: <20190814165750.919436537@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 1957de95d425d1c06560069dc7277a73a8b28683 upstream.

When instantiating tcpm on an NXP OM 13588 board with NXP PTN5110,
the following crash is seen when writing into the 'preferred_role'
sysfs attribute.

Unable to handle kernel NULL pointer dereference at virtual address 00000028
pgd = f69149ad
[00000028] *pgd=00000000
Internal error: Oops: 5 [#1] THUMB2
Modules linked in: tcpci tcpm
CPU: 0 PID: 1882 Comm: bash Not tainted 5.1.18-sama5-armv7-r2 #4
Hardware name: Atmel SAMA5
PC is at tcpm_try_role+0x3a/0x4c [tcpm]
LR is at tcpm_try_role+0x15/0x4c [tcpm]
pc : [<bf8000e2>]    lr : [<bf8000bd>]    psr: 60030033
sp : dc1a1e88  ip : c03fb47d  fp : 00000000
r10: dc216190  r9 : dc1a1f78  r8 : 00000001
r7 : df4ae044  r6 : dd032e90  r5 : dd1ce340  r4 : df4ae054
r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : df4ae044
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment none
Control: 50c53c7d  Table: 3efec059  DAC: 00000051
Process bash (pid: 1882, stack limit = 0x6a6d4aa5)
Stack: (0xdc1a1e88 to 0xdc1a2000)
1e80:                   dd05d808 dd1ce340 00000001 00000007 dd1ce340 c03fb4a7
1ea0: 00000007 00000007 dc216180 00000000 00000000 c01e1e03 00000000 00000000
1ec0: c0907008 dee98b40 c01e1d5d c06106c4 00000000 00000000 00000007 c0194e8b
1ee0: 0000000a 00000400 00000000 c01a97db dc22bf00 ffffe000 df4b6a00 df745900
1f00: 00000001 00000001 000000dd c01a9c2f 7aeab3be c0907008 00000000 dc22bf00
1f20: c0907008 00000000 00000000 00000000 00000000 7aeab3be 00000007 dee98b40
1f40: 005dc318 dc1a1f78 00000000 00000000 00000007 c01969f7 0000000a c01a20cb
1f60: dee98b40 c0907008 dee98b40 005dc318 00000000 c0196b9b 00000000 00000000
1f80: dee98b40 7aeab3be 00000074 005dc318 b6f3bdb0 00000004 c0101224 dc1a0000
1fa0: 00000004 c0101001 00000074 005dc318 00000001 005dc318 00000007 00000000
1fc0: 00000074 005dc318 b6f3bdb0 00000004 00000007 00000007 00000000 00000000
1fe0: 00000004 be800880 b6ed35b3 b6e5c746 60030030 00000001 00000000 00000000
[<bf8000e2>] (tcpm_try_role [tcpm]) from [<c03fb4a7>] (preferred_role_store+0x2b/0x5c)
[<c03fb4a7>] (preferred_role_store) from [<c01e1e03>] (kernfs_fop_write+0xa7/0x150)
[<c01e1e03>] (kernfs_fop_write) from [<c0194e8b>] (__vfs_write+0x1f/0x104)
[<c0194e8b>] (__vfs_write) from [<c01969f7>] (vfs_write+0x6b/0x104)
[<c01969f7>] (vfs_write) from [<c0196b9b>] (ksys_write+0x43/0x94)
[<c0196b9b>] (ksys_write) from [<c0101001>] (ret_fast_syscall+0x1/0x62)

Since commit 96232cbc6c994 ("usb: typec: tcpm: support get typec and pd
config from device properties"), the 'config' pointer in struct tcpc_dev
is optional when registering a Type-C port. Since it is optional, we have
to check if it is NULL before dereferencing it.

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Fixes: 96232cbc6c994 ("usb: typec: tcpm: support get typec and pd config from device properties")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/1563979112-22483-1-git-send-email-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -378,7 +378,8 @@ static enum tcpm_state tcpm_default_stat
 			return SNK_UNATTACHED;
 		else if (port->try_role == TYPEC_SOURCE)
 			return SRC_UNATTACHED;
-		else if (port->tcpc->config->default_role == TYPEC_SINK)
+		else if (port->tcpc->config &&
+			 port->tcpc->config->default_role == TYPEC_SINK)
 			return SNK_UNATTACHED;
 		/* Fall through to return SRC_UNATTACHED */
 	} else if (port->port_type == TYPEC_PORT_SNK) {
@@ -4096,7 +4097,7 @@ static int tcpm_try_role(const struct ty
 	mutex_lock(&port->lock);
 	if (tcpc->try_role)
 		ret = tcpc->try_role(tcpc, role);
-	if (!ret && !tcpc->config->try_role_hw)
+	if (!ret && (!tcpc->config || !tcpc->config->try_role_hw))
 		port->try_role = role;
 	port->try_src_count = 0;
 	port->try_snk_count = 0;
@@ -4743,7 +4744,7 @@ static int tcpm_copy_caps(struct tcpm_po
 	port->typec_caps.prefer_role = tcfg->default_role;
 	port->typec_caps.type = tcfg->type;
 	port->typec_caps.data = tcfg->data;
-	port->self_powered = port->tcpc->config->self_powered;
+	port->self_powered = tcfg->self_powered;
 
 	return 0;
 }


