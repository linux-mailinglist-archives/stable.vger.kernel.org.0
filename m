Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1BA116217
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLHN5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60156 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLHNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0007em-87; Sun, 08 Dec 2019 13:54:39 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0002Ng-9e; Sun, 08 Dec 2019 13:54:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sebastian Ott" <sebott@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>
Date:   Sun, 08 Dec 2019 13:53:25 +0000
Message-ID: <lsq.1575813165.739244209@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 41/72] s390/cio: avoid calling strlen on null pointer
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit ea298e6ee8b34b3ed4366be7eb799d0650ebe555 upstream.

Fix the following kasan finding:
BUG: KASAN: global-out-of-bounds in ccwgroup_create_dev+0x850/0x1140
Read of size 1 at addr 0000000000000000 by task systemd-udevd.r/561

CPU: 30 PID: 561 Comm: systemd-udevd.r Tainted: G    B
Hardware name: IBM 3906 M04 704 (LPAR)
Call Trace:
([<0000000231b3db7e>] show_stack+0x14e/0x1a8)
 [<0000000233826410>] dump_stack+0x1d0/0x218
 [<000000023216fac4>] print_address_description+0x64/0x380
 [<000000023216f5a8>] __kasan_report+0x138/0x168
 [<00000002331b8378>] ccwgroup_create_dev+0x850/0x1140
 [<00000002332b618a>] group_store+0x3a/0x50
 [<00000002323ac706>] kernfs_fop_write+0x246/0x3b8
 [<00000002321d409a>] vfs_write+0x132/0x450
 [<00000002321d47da>] ksys_write+0x122/0x208
 [<0000000233877102>] system_call+0x2a6/0x2c8

Triggered by:
openat(AT_FDCWD, "/sys/bus/ccwgroup/drivers/qeth/group",
		O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 16
write(16, "0.0.bd00,0.0.bd01,0.0.bd02", 26) = 26

The problem is that __get_next_id in ccwgroup_create_dev might set "buf"
buffer pointer to NULL and explicit check for that is required.

Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/cio/ccwgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -369,7 +369,7 @@ int ccwgroup_create_dev(struct device *p
 		goto error;
 	}
 	/* Check for trailing stuff. */
-	if (i == num_devices && strlen(buf) > 0) {
+	if (i == num_devices && buf && strlen(buf) > 0) {
 		rc = -EINVAL;
 		goto error;
 	}

