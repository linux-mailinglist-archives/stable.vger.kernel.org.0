Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7019D450C6C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhKORir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236880AbhKORhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B5C6327F;
        Mon, 15 Nov 2021 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997061;
        bh=VH4eJvRr6jEUK+SbpVHW54B1jiuFyCPB0mZFMJpAsEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sf82Qte4etdKtJlePezX77+T/hsca82dOJju4JzL8ExcjUkJ7CQ7uKkuW/9HPF1lS
         mn/SGKJedWEZ61Taq9dW2iQwXqjI8sG9KNtJK3I1CKxM4RORiYJfPu/nATd9LPTyM1
         TQVkEQtkKewAHKm8J5hb0O8Z5yXXCIFYIb71ihG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 012/575] scsi: qla2xxx: Fix kernel crash when accessing port_speed sysfs file
Date:   Mon, 15 Nov 2021 17:55:37 +0100
Message-Id: <20211115165344.030192104@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 3ef68d4f0c9e7cb589ae8b70f07d77f528105331 upstream.

Kernel crashes when accessing port_speed sysfs file.  The issue happens on
a CNA when the local array was accessed beyond bounds. Fix this by changing
the lookup.

BUG: unable to handle kernel paging request at 0000000000004000
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 15 PID: 455213 Comm: sosreport Kdump: loaded Not tainted
4.18.0-305.7.1.el8_4.x86_64 #1
RIP: 0010:string_nocheck+0x12/0x70
Code: 00 00 4c 89 e2 be 20 00 00 00 48 89 ef e8 86 9a 00 00 4c 01
e3 eb 81 90 49 89 f2 48 89 ce 48 89 f8 48 c1 fe 30 66 85 f6 74 4f <44> 0f b6 0a
45 84 c9 74 46 83 ee 01 41 b8 01 00 00 00 48 8d 7c 37
RSP: 0018:ffffb5141c1afcf0 EFLAGS: 00010286
RAX: ffff8bf4009f8000 RBX: ffff8bf4009f9000 RCX: ffff0a00ffffff04
RDX: 0000000000004000 RSI: ffffffffffffffff RDI: ffff8bf4009f8000
RBP: 0000000000004000 R08: 0000000000000001 R09: ffffb5141c1afb84
R10: ffff8bf4009f9000 R11: ffffb5141c1afce6 R12: ffff0a00ffffff04
R13: ffffffffc08e21aa R14: 0000000000001000 R15: ffffffffc08e21aa
FS:  00007fc4ebfff700(0000) GS:ffff8c717f7c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000004000 CR3: 000000edfdee6006 CR4: 00000000001706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  string+0x40/0x50
  vsnprintf+0x33c/0x520
  scnprintf+0x4d/0x90
  qla2x00_port_speed_show+0xb5/0x100 [qla2xxx]
  dev_attr_show+0x1c/0x40
  sysfs_kf_seq_show+0x9b/0x100
  seq_read+0x153/0x410
  vfs_read+0x91/0x140
  ksys_read+0x4f/0xb0
  do_syscall_64+0x5b/0x1a0
  entry_SYSCALL_64_after_hwframe+0x65/0xca

Link: https://lore.kernel.org/r/20210908164622.19240-7-njavali@marvell.com
Fixes: 4910b524ac9e ("scsi: qla2xxx: Add support for setting port speed")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1862,6 +1862,18 @@ qla2x00_port_speed_store(struct device *
 	return strlen(buf);
 }
 
+static const struct {
+	u16 rate;
+	char *str;
+} port_speed_str[] = {
+	{ PORT_SPEED_4GB, "4" },
+	{ PORT_SPEED_8GB, "8" },
+	{ PORT_SPEED_16GB, "16" },
+	{ PORT_SPEED_32GB, "32" },
+	{ PORT_SPEED_64GB, "64" },
+	{ PORT_SPEED_10GB, "10" },
+};
+
 static ssize_t
 qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
     char *buf)
@@ -1869,7 +1881,8 @@ qla2x00_port_speed_show(struct device *d
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 	ssize_t rval;
-	char *spd[7] = {"0", "0", "0", "4", "8", "16", "32"};
+	u16 i;
+	char *speed = "Unknown";
 
 	rval = qla2x00_get_data_rate(vha);
 	if (rval != QLA_SUCCESS) {
@@ -1878,7 +1891,14 @@ qla2x00_port_speed_show(struct device *d
 		return -EINVAL;
 	}
 
-	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
+	for (i = 0; i < ARRAY_SIZE(port_speed_str); i++) {
+		if (port_speed_str[i].rate != ha->link_data_rate)
+			continue;
+		speed = port_speed_str[i].str;
+		break;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", speed);
 }
 
 /* ----- */


