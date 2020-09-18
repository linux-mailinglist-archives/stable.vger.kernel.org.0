Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26008270604
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 22:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIRUJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 16:09:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:55832 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgIRUJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 16:09:40 -0400
IronPort-SDR: gfcom4Dn9Nin84vgNtsnbtzXlYUL3Rmre38W0IQTtIlfNfIU0+cMbt+ONXGUvUhwX0vyEYa6ZX
 OFbyNtQfWQcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="139523467"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="139523467"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 13:09:36 -0700
IronPort-SDR: FJ/6JqWmW3mzc9id45K/pUifIhma9iO/tpvqENgotQ7/j0NXCucHsFf52V1O9z0gsd9NnEHi8d
 RfrPozsiyvKQ==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="288094607"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 13:09:35 -0700
Subject: [PATCH] dm/dax: Fix table reference counts
From:   Dan Williams <dan.j.williams@intel.com>
To:     dm-devel@redhat.com
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Adrian Huang <ahuang12@lenovo.com>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 18 Sep 2020 12:51:15 -0700
Message-ID: <160045867590.25663.7548541079217827340.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fb0255d25e4b..4a40df8af7d3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1136,15 +1136,16 @@ static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bd
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

