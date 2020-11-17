Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7CE2B6399
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbgKQNjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:39:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732734AbgKQNji (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB4C2468D;
        Tue, 17 Nov 2020 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620376;
        bh=BJxXwPFVPC2oTDeqVeV3w+TrQZ3GLWMOJ91YNGurQC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co/jX+Fp8UqU42uprUhBHb0Ng77+Vw8yFRDzUg7iB5UBcewduS/jxIoYsRdVwgLSZ
         DpDsGSfLVWkkTOZ8lnml50MLJ3THlmnAFh2J5Heyve8EEsxssR+ZisVjMMNUdrWG35
         JAWzgGDrLD8yIfor8xzzsFCUNKxvTVSqHn51brcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ltp@lists.linux.it,
        Petr Vorel <pvorel@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 198/255] loop: Fix occasional uevent drop
Date:   Tue, 17 Nov 2020 14:05:38 +0100
Message-Id: <20201117122148.567147400@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <pvorel@suse.cz>

commit c01a21b77722db0474bbcc4eafc8c4e0d8fed6d8 upstream.

Commit 716ad0986cbd ("loop: Switch to set_capacity_revalidate_and_notify")
causes an occasional drop of loop device uevent, which are no longer
triggered in loop_set_size() but in a different part of code.

Bug is reproducible with LTP test uevent01 [1]:

i=0; while true; do
    i=$((i+1)); echo "== $i =="
    lsmod |grep -q loop && rmmod -f loop
    ./uevent01 || break
done

Put back triggering through code called in loop_set_size().

Fix required to add yet another parameter to
set_capacity_revalidate_and_notify().

[1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/uevents/uevent01.c

[hch: rebased on a different change to the prototype of
 set_capacity_revalidate_and_notify]

Cc: stable@vger.kernel.org # v5.9
Fixes: 716ad0986cbd ("loop: Switch to set_capacity_revalidate_and_notify")
Reported-by: <ltp@lists.linux.it>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -255,7 +255,8 @@ static void loop_set_size(struct loop_de
 
 	bd_set_size(bdev, size << SECTOR_SHIFT);
 
-	set_capacity_revalidate_and_notify(lo->lo_disk, size, false);
+	if (!set_capacity_revalidate_and_notify(lo->lo_disk, size, false))
+		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 }
 
 static inline int


