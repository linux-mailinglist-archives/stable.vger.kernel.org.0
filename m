Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25E4E690A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfJ0VLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729814AbfJ0VLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:00 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C589214E0;
        Sun, 27 Oct 2019 21:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210659;
        bh=t/wq/WZPF0b75fqr10+zFJOVGpK2Dc4F7FNpxG8v3bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzxS1LnUIxdoIRZqfIfuJZoCSf8mABIKElKH8qZUuZeyTzLEmyfgaMq3YWpMTTHs5
         NC4rVFgqakg8/PMunHbBIvdP4N8VGX54X/qVFso5KoerIfWGh4PpP7+XxcfOMOCd82
         fahNf43fgEnXTPd+WDbmaQkg+CxnbZwXDEp998VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Rob Turk <robtu@rtist.nl>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 090/119] scsi: ch: Make it possible to open a ch device multiple times again
Date:   Sun, 27 Oct 2019 22:01:07 +0100
Message-Id: <20191027203348.205230988@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 6a0990eaa768dfb7064f06777743acc6d392084b upstream.

Clearing ch->device in ch_release() is wrong because that pointer must
remain valid until ch_remove() is called. This patch fixes the following
crash the second time a ch device is opened:

BUG: kernel NULL pointer dereference, address: 0000000000000790
RIP: 0010:scsi_device_get+0x5/0x60
Call Trace:
 ch_open+0x4c/0xa0 [ch]
 chrdev_open+0xa2/0x1c0
 do_dentry_open+0x13a/0x380
 path_openat+0x591/0x1470
 do_filp_open+0x91/0x100
 do_sys_open+0x184/0x220
 do_syscall_64+0x5f/0x1a0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 085e56766f74 ("scsi: ch: add refcounting")
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191009173536.247889-1-bvanassche@acm.org
Reported-by: Rob Turk <robtu@rtist.nl>
Suggested-by: Rob Turk <robtu@rtist.nl>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ch.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -578,7 +578,6 @@ ch_release(struct inode *inode, struct f
 	scsi_changer *ch = file->private_data;
 
 	scsi_device_put(ch->device);
-	ch->device = NULL;
 	file->private_data = NULL;
 	kref_put(&ch->ref, ch_destroy);
 	return 0;


