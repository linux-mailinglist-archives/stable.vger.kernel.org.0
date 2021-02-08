Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C853136E2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhBHPRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhBHPMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2346A64EF0;
        Mon,  8 Feb 2021 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796943;
        bh=BsInV7Qqjs9IreVVDcQb8FYQrXw1uxJaS1Yl21zguqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwFIULyADyzkaIFj/3p4Y66Y20TpzAyt/E9R6EfKdLe8z1KNAH273qVllTFbe/hfP
         ErRjAm3p127YMfWFf0O+xm15icbeaNU8n5YYW3wvJ7lFAedlUVmwFdpMX9p0wIFA9P
         62zh0UNdnCAhM0ChB7L0Li2sd899Tu0m+oAWV8mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jeffery <djeffery@redhat.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 36/38] md: Set prev_flush_start and flush_bio in an atomic way
Date:   Mon,  8 Feb 2021 16:01:23 +0100
Message-Id: <20210208145807.613541970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit dc5d17a3c39b06aef866afca19245a9cfb533a79 upstream.

One customer reports a crash problem which causes by flush request. It
triggers a warning before crash.

        /* new request after previous flush is completed */
        if (ktime_after(req_start, mddev->prev_flush_start)) {
                WARN_ON(mddev->flush_bio);
                mddev->flush_bio = bio;
                bio = NULL;
        }

The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
flush_bio in md_flush_request. But there is no lock protection in
md_submit_flush_data. It can set flush_bio to NULL first because of
compiler reordering write instructions.

For example, flush bio1 sets flush bio to NULL first in
md_submit_flush_data. An interrupt or vmware causing an extended stall
happen between updating flush_bio and prev_flush_start. Because flush_bio
is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
flush bio1 updates prev_flush_start after the interrupt or extended stall.

Then flush bio3 enters in md_flush_request. The start time req_start is
behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
again. INIT_WORK() will re-initialize the list pointers in the
work_struct, which then can result in a corrupted work list and the
work_struct queued a second time. With the work list corrupted, it can
lead in invalid work items being used and cause a crash in
process_one_work.

We need to make sure only one flush bio can be handled at one same time.
So add spin lock in md_submit_flush_data to protect prev_flush_start and
flush_bio in an atomic way.

Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -474,8 +474,10 @@ static void md_submit_flush_data(struct
 	 * could wait for this and below md_handle_request could wait for those
 	 * bios because of suspend check
 	 */
+	spin_lock_irq(&mddev->lock);
 	mddev->last_flush = mddev->start_flush;
 	mddev->flush_bio = NULL;
+	spin_unlock_irq(&mddev->lock);
 	wake_up(&mddev->sb_wait);
 
 	if (bio->bi_iter.bi_size == 0) {


