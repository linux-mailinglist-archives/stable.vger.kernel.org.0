Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C9D272EFF
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgIUQrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgIUQrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE7E2389F;
        Mon, 21 Sep 2020 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706836;
        bh=gVPWHHVsRgwOVX6wf9/4LT+JI3nRH5Pmckx3O+v6esA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8u6n7LnxusZnG902U6w1b17tnyNJlo4LKMWZeqg7fhpzti5s8RODVWTuZjotm1jM
         D8kDyxbRIDcKEwSx/o9UrpjhgX4NI+70TquvdNdSRmzflRMuZ6MKUfIdBfMgqBjsEO
         JXzpm7HxlZYwld7KBUldluhR7LCFahixjV2Sjo3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Adrian Huang <ahuang12@lenovo.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.8 113/118] dm/dax: Fix table reference counts
Date:   Mon, 21 Sep 2020 18:28:45 +0200
Message-Id: <20200921162041.637820805@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 02186d8897d49b0afd3c80b6cf23437d91024065 upstream.

A recent fix to the dm_dax_supported() flow uncovered a latent bug. When
dm_get_live_table() fails it is still required to drop the
srcu_read_lock(). Without this change the lvm2 test-suite triggers this
warning:

    # lvm2-testsuite --only pvmove-abort-all.sh

    WARNING: lock held when returning to user space!
    5.9.0-rc5+ #251 Tainted: G           OE
    ------------------------------------------------
    lvm/1318 is leaving the kernel with locks still held!
    1 lock held by lvm/1318:
     #0: ffff9372abb5a340 (&md->io_barrier){....}-{0:0}, at: dm_get_live_table+0x5/0xb0 [dm_mod]

...and later on this hang signature:

    INFO: task lvm:1344 blocked for more than 122 seconds.
          Tainted: G           OE     5.9.0-rc5+ #251
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    task:lvm             state:D stack:    0 pid: 1344 ppid:     1 flags:0x00004000
    Call Trace:
     __schedule+0x45f/0xa80
     ? finish_task_switch+0x249/0x2c0
     ? wait_for_completion+0x86/0x110
     schedule+0x5f/0xd0
     schedule_timeout+0x212/0x2a0
     ? __schedule+0x467/0xa80
     ? wait_for_completion+0x86/0x110
     wait_for_completion+0xb0/0x110
     __synchronize_srcu+0xd1/0x160
     ? __bpf_trace_rcu_utilization+0x10/0x10
     __dm_suspend+0x6d/0x210 [dm_mod]
     dm_suspend+0xf6/0x140 [dm_mod]

Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multiple devices")
Cc: <stable@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Reported-by: Adrian Huang <ahuang12@lenovo.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Adrian Huang <ahuang12@lenovo.com>
Link: https://lore.kernel.org/r/160045867590.25663.7548541079217827340.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1136,15 +1136,16 @@ static bool dm_dax_supported(struct dax_
 {
 	struct mapped_device *md = dax_get_private(dax_dev);
 	struct dm_table *map;
+	bool ret = false;
 	int srcu_idx;
-	bool ret;
 
 	map = dm_get_live_table(md, &srcu_idx);
 	if (!map)
-		return false;
+		goto out;
 
 	ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);
 
+out:
 	dm_put_live_table(md, srcu_idx);
 
 	return ret;


