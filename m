Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E66163274
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgBRT7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgBRT7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E0124670;
        Tue, 18 Feb 2020 19:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055953;
        bh=O9r5i8nqHSQAto/Wve6Tojb8JBvbpPLEf6XmOAKP9Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfY9SxpW+upfvyEsxi7Rd9qcjEXaYWCaPFNm0LK6k+zU7t+1yuxc0QVYJL9M506ug
         PUzTpoVykBaw+2/Sf1o1yBQgYfTRB92AnO2H0NwcgDPMExXzTzxbtLBCmUwqmn2SOj
         UZIwTsvcKxQN6unb/jHM0Hj/rvOI3Cw4S/CzMiJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonatan Cohen <yonatanc@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 43/66] IB/umad: Fix kernel crash while unloading ib_umad
Date:   Tue, 18 Feb 2020 20:55:10 +0100
Message-Id: <20200218190431.979466384@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

commit 9ea04d0df6e6541c6736b43bff45f1e54875a1db upstream.

When disassociating a device from umad we must ensure that the sysfs
access is prevented before blocking the fops, otherwise assumptions in
syfs don't hold:

	    CPU0            	        CPU1
	 ib_umad_kill_port()        ibdev_show()
	    port->ib_dev = NULL
                                      dev_name(port->ib_dev)

The prior patch made an error in moving the device_destroy(), it should
have been split into device_del() (above) and put_device() (below). At
this point we already have the split, so move the device_del() back to its
original place.

  kernel stack
  PF: error_code(0x0000) - not-present page
  Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
  RIP: 0010:ibdev_show+0x18/0x50 [ib_umad]
  RSP: 0018:ffffc9000097fe40 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffffffffa0441120 RCX: ffff8881df514000
  RDX: ffff8881df514000 RSI: ffffffffa0441120 RDI: ffff8881df1e8870
  RBP: ffffffff81caf000 R08: ffff8881df1e8870 R09: 0000000000000000
  R10: 0000000000001000 R11: 0000000000000003 R12: ffff88822f550b40
  R13: 0000000000000001 R14: ffffc9000097ff08 R15: ffff8882238bad58
  FS:  00007f1437ff3740(0000) GS:ffff888236940000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000004e8 CR3: 00000001e0dfc001 CR4: 00000000001606e0
  Call Trace:
   dev_attr_show+0x15/0x50
   sysfs_kf_seq_show+0xb8/0x1a0
   seq_read+0x12d/0x350
   vfs_read+0x89/0x140
   ksys_read+0x55/0xd0
   do_syscall_64+0x55/0x1b0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9:

Fixes: cf7ad3030271 ("IB/umad: Avoid destroying device while it is accessed")
Link: https://lore.kernel.org/r/20200212072635.682689-9-leon@kernel.org
Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/user_mad.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1312,6 +1312,9 @@ static void ib_umad_kill_port(struct ib_
 	struct ib_umad_file *file;
 	int id;
 
+	cdev_device_del(&port->sm_cdev, &port->sm_dev);
+	cdev_device_del(&port->cdev, &port->dev);
+
 	mutex_lock(&port->file_mutex);
 
 	/* Mark ib_dev NULL and block ioctl or other file ops to progress
@@ -1331,8 +1334,6 @@ static void ib_umad_kill_port(struct ib_
 
 	mutex_unlock(&port->file_mutex);
 
-	cdev_device_del(&port->sm_cdev, &port->sm_dev);
-	cdev_device_del(&port->cdev, &port->dev);
 	ida_free(&umad_ida, port->dev_num);
 
 	/* balances device_initialize() */


