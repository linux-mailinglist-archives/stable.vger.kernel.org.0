Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3250925DB45
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgIDNmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbgIDNmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:42:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94A520C09;
        Fri,  4 Sep 2020 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226227;
        bh=aTdgrapGl6hhy72V1j6OvtPhsNpHmNOqrIOa/HJfm8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nE87rAyXzK6VI1WLFVLiKC9cALLyVrFxJbyW6cpgXaJfvcR1Mj9De6yhJcY7ImuwJ
         xHbpVCrlpZbx9sWbMrQBBLGpbJpO8+wgpI8O5mSl1k6vo9EX8sK+aQxwVeXKh8MutI
         zI0PAsTPPuzBv0YMUjCrnqueqqJadda9oVvppF0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 15/16] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
Date:   Fri,  4 Sep 2020 15:30:08 +0200
Message-Id: <20200904120257.940624145@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

commit 8c4e0f212398cdd1eb4310a5981d06a723cdd24f upstream.

1) If remaining ring space before the end of the ring is smaller then the
   next cmd to write, tcmu writes a padding entry which fills the remaining
   space at the end of the ring.

   Then tcmu calls tcmu_flush_dcache_range() with the size of struct
   tcmu_cmd_entry as data length to flush.  If the space filled by the
   padding was smaller then tcmu_cmd_entry, tcmu_flush_dcache_range() is
   called for an address range reaching behind the end of the vmalloc'ed
   ring.

   tcmu_flush_dcache_range() in a loop calls
   flush_dcache_page(virt_to_page(start)); for every page being part of the
   range. On x86 the line is optimized out by the compiler, as
   flush_dcache_page() is empty on x86.

   But I assume the above can cause trouble on other architectures that
   really have a flush_dcache_page().  For paddings only the header part of
   an entry is relevant due to alignment rules the header always fits in
   the remaining space, if padding is needed.  So tcmu_flush_dcache_range()
   can safely be called with sizeof(entry->hdr) as the length here.

2) After it has written a command to cmd ring, tcmu calls
   tcmu_flush_dcache_range() using the size of a struct tcmu_cmd_entry as
   data length to flush.  But if a command needs many iovecs, the real size
   of the command may be bigger then tcmu_cmd_entry, so a part of the
   written command is not flushed then.

Link: https://lore.kernel.org/r/20200528193108.9085-1-bstroesser@ts.fujitsu.com
Acked-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1007,7 +1007,7 @@ static int queue_cmd_ring(struct tcmu_cm
 		entry->hdr.cmd_id = 0; /* not used for PAD */
 		entry->hdr.kflags = 0;
 		entry->hdr.uflags = 0;
-		tcmu_flush_dcache_range(entry, sizeof(*entry));
+		tcmu_flush_dcache_range(entry, sizeof(entry->hdr));
 
 		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
 		tcmu_flush_dcache_range(mb, sizeof(*mb));
@@ -1072,7 +1072,7 @@ static int queue_cmd_ring(struct tcmu_cm
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
 	entry->req.cdb_off = cdb_off;
-	tcmu_flush_dcache_range(entry, sizeof(*entry));
+	tcmu_flush_dcache_range(entry, command_size);
 
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
 	tcmu_flush_dcache_range(mb, sizeof(*mb));


