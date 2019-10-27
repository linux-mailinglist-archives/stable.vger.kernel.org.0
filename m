Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBD7E6793
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbfJ0VWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbfJ0VWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:10 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A722070B;
        Sun, 27 Oct 2019 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211329;
        bh=qSmlTE+QgmSY9E9tC6knfwegASSxSRMMw6TO5CL9/D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDLrfVOdUXHauLiQ4cvnPQY9sIkE1W4kmWxWLwxobS2k/UrLrTJwsSXVAvtTQU3Br
         u1oRefYbt4VeOTpXRL3F9Bc68sRqTB1xA+y2palmlw1Y5/PcRORAxQKoG3nnd+lM2e
         i0tRhKA66JXCaYkRZokFb/ZIUza/yuRlApgAXEow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Rob Turk <robtu@rtist.nl>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.3 113/197] scsi: ch: Make it possible to open a ch device multiple times again
Date:   Sun, 27 Oct 2019 22:00:31 +0100
Message-Id: <20191027203357.843173402@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
@@ -579,7 +579,6 @@ ch_release(struct inode *inode, struct f
 	scsi_changer *ch = file->private_data;
 
 	scsi_device_put(ch->device);
-	ch->device = NULL;
 	file->private_data = NULL;
 	kref_put(&ch->ref, ch_destroy);
 	return 0;


