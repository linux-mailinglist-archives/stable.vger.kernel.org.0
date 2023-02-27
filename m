Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0416A45F9
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjB0PX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 10:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB0PX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 10:23:26 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C689576B2
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 07:23:25 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 822D41FD65;
        Mon, 27 Feb 2023 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677511404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hZqDlVGGUc4d7B4la/0bWvCQjH9D5kQ/qNOyRrHwAZY=;
        b=tvvGNaF5vTMiZShYostjSn/wS1yp3YHV8TICLaWWWEINwizuzKPMVFvNjSkeKhMZmZi1OW
        6HBXK4pSwuJnEJyqSRc432JV6KTdbc7CQP6RzFPtsjn7Und3K5AhcLC63aMCejjjJy4Bqc
        lw0zrYKeapGz+Ev0uxo02lpWYH1wPfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677511404;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hZqDlVGGUc4d7B4la/0bWvCQjH9D5kQ/qNOyRrHwAZY=;
        b=dgWqYMqZtwtF1lQ9uMsyA+MtGFUh7RyPACd9oBYEoKNhdNQ90CsNcZ+tHNE3ErJh94vh1Y
        6N3/o81Jmu9KyeDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A8B162C141;
        Mon, 27 Feb 2023 15:23:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     snitzer@kernel.org
Cc:     dm-devel@redhat.com, Coly Li <colyli@suse.de>,
        Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] Avoid deadlock for recursive I/O on dm-thin when used as swap
Date:   Mon, 27 Feb 2023 23:23:17 +0800
Message-Id: <20230227152317.32684-1-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an alrady known issue that dm-thin volume cannot be used as
swap, otherwise a deadlock may happen when dm-thin internal memory
demond triggers swap I/O on the dm-thin volume itself.

Thanks to Mikulas Patocka for commit a666e5c05e7c ("dm: fix deadlock
when swapping to encrypted device"), this method can also be used for
dm-thin to avoid the recursive I/O when it is used as swap.

This patch just simply sets ti->limit_swap_bios by tree in pool_ctr()
and thin_ctr(), other important stuffs are already done by Patocka in
the above mentioned commit.

In my test, I create a dm-thin volume /dev/vg/swap and use it as swap
device. Then I run fio on another dm-thin volume /dev/vg/main and use
large --blocksize to trigger swap I/O onto /dev/vg/swap.

The following fio command line is used in my test,
  fio --name recursive-swap-io --lockmem 1 --iodepth 128 \
     --ioengine libaio --filename /dev/vg/main --rw randrw \
    --blocksize 1M --numjobs 32 --time_based --runtime=12h

Without the patch, the whole system can be locked up within 15 seconds.

With this patch, there is no any deadlock or hang task observed after
2 hours fio running.

Further more, I change --blocksize from 1M to 128M, around 30 seconds
after fio running, no I/O rate displayed by fio, and the out-of-memory
killer message shows up in kernel message. After around 20 minutes all
fio processes are killed and the whole system backs to be alive.

This is exactly what is expected when recursive I/O happens on dm-thin
volume when it is used as swap.

Note: this change depends on commit a666e5c05e7c ("dm: fix deadlock when
swapping to encrypted device")

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: stable@vger.kernel.org
---
Changelog,
v2: fix typo in commit log.
v1: initial version.

 drivers/md/dm-thin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3355,6 +3355,7 @@ static int pool_ctr(struct dm_target *ti
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4233,6 +4234,7 @@ static int thin_ctr(struct dm_target *ti
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
