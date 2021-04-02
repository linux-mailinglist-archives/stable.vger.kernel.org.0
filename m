Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB1B35301E
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 22:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhDBUIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 16:08:46 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:39920 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhDBUIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 16:08:46 -0400
Received: by mail-pj1-f43.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so5035229pjb.4
        for <stable@vger.kernel.org>; Fri, 02 Apr 2021 13:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3dwpWREjo4Fa//x6Xdonleo7aiSQbfEpLvexm/DxwVg=;
        b=Rmum2SL7YKSDU/o9rDg6iz1qgb4G0BlFfel4iLu5vpGyObZr+6K+uUQ2AzGH9Wfp5z
         +pbENpEZoyFM347tNrxDITAOJLVxDwJ6wZQMu0YBUTDWnxrBPDwHZLXWFANphs9NPkxm
         zm6/rif7LanrYqq08bLod9tqz1Twy91c+xEpH68RYAMop8CEgZUba7RTVVCxhr5Kfjuv
         jyYuahMUxLjTJSxhvCF/f0KlFMnUMdqYQ9pEWQbsovTXn/3+mQoQJPkTXbocZuqGEwo0
         7z/9+wfFe21+VXZCHUxpYKZ0gQVHjHVNwkEmulWTHdmMVwNbaBhAFCnKOpppOJIJVV7b
         r1Lw==
X-Gm-Message-State: AOAM5313sKcQYYKynUeFCVUhYnGsdkX7FWSPKzfwgDcKhiqPkHb5uy63
        ViAFbJEkTX3IRFMn9pv29SnjoEuqi9s=
X-Google-Smtp-Source: ABdhPJx0rt4hE3P6WhMiDsGjg3hsS0NHcCJ545zVm8R9Y0kTVwN3dLQtLRuG8r0EEASq05pVRpg75w==
X-Received: by 2002:a17:902:ea0d:b029:e6:f01d:9db5 with SMTP id s13-20020a170902ea0db02900e6f01d9db5mr14031764plg.60.1617394123970;
        Fri, 02 Apr 2021 13:08:43 -0700 (PDT)
Received: from sagi-Latitude-7490.hsd1.ca.comcast.net ([2601:647:4802:9070:de32:cc5:ecd7:105c])
        by smtp.gmail.com with ESMTPSA id n6sm5635854pfq.214.2021.04.02.13.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 13:08:43 -0700 (PDT)
From:   Sagi Grimberg <sagi@grimberg.me>
To:     <stable@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org
Subject: [PATCH stable/5.4..5.8] nvme-mpath: replace direct_make_request with generic_make_request
Date:   Fri,  2 Apr 2021 13:08:41 -0700
Message-Id: <20210402200841.347696-1-sagi@grimberg.me>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The below patches caused a regression in a multipath setup:
Fixes: 9f98772ba307 ("nvme-rdma: fix controller reset hang during traffic")
Fixes: 2875b0aecabe ("nvme-tcp: fix controller reset hang during traffic")

These patches on their own are correct because they fixed a controller reset
regression.

When we reset/teardown a controller, we must freeze and quiesce the namespaces
request queues to make sure that we safely stop inflight I/O submissions.
Freeze is mandatory because if our hctx map changed between reconnects,
blk_mq_update_nr_hw_queues will immediately attempt to freeze the queue, and
if it still has pending submissions (that are still quiesced) it will hang.
This is what the above patches fixed.

However, by freezing the namespaces request queues, and only unfreezing them
when we successfully reconnect, inflight submissions that are running
concurrently can now block grabbing the nshead srcu until either we successfully
reconnect or ctrl_loss_tmo expired (or the user explicitly disconnected).

This caused a deadlock [1] when a different controller (different path on the
same subsystem) became live (i.e. optimized/non-optimized). This is because
nvme_mpath_set_live needs to synchronize the nshead srcu before requeueing I/O
in order to make sure that current_path is visible to future (re)submisions.
However the srcu lock is taken by a blocked submission on a frozen request
queue, and we have a deadlock.

In recent kernels (v5.9+) direct_make_request was replaced by submit_bio_noacct
which does not have this issue because it bio_list will be active when
nvme-mpath calls submit_bio_noacct on the bottom device (because it was
populated when submit_bio was triggered on it.

Hence, we need to fix all the kernels that were before submit_bio_noacct was
introduced.

[1]:
Workqueue: nvme-wq nvme_tcp_reconnect_ctrl_work [nvme_tcp]
Call Trace:
 __schedule+0x293/0x730
 schedule+0x33/0xa0
 schedule_timeout+0x1d3/0x2f0
 wait_for_completion+0xba/0x140
 __synchronize_srcu.part.21+0x91/0xc0
 synchronize_srcu_expedited+0x27/0x30
 synchronize_srcu+0xce/0xe0
 nvme_mpath_set_live+0x64/0x130 [nvme_core]
 nvme_update_ns_ana_state+0x2c/0x30 [nvme_core]
 nvme_update_ana_state+0xcd/0xe0 [nvme_core]
 nvme_parse_ana_log+0xa1/0x180 [nvme_core]
 nvme_read_ana_log+0x76/0x100 [nvme_core]
 nvme_mpath_init+0x122/0x180 [nvme_core]
 nvme_init_identify+0x80e/0xe20 [nvme_core]
 nvme_tcp_setup_ctrl+0x359/0x660 [nvme_tcp]
 nvme_tcp_reconnect_ctrl_work+0x24/0x70 [nvme_tcp]

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
Note: This patch does not exist in upstream, it is a pure
backport fix that was just now found. The reason for that is
that this specific issue exists on on kernels 5.4-5.8 as it
was fixed in 5.9, and the patches that caused this was only
backported to linux-5.4.y (which are correct as mentioned
in the patch description)

 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 041a755f936a..0d9d0bebe645 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -339,7 +339,7 @@ static blk_qc_t nvme_ns_head_make_request(struct request_queue *q,
 		trace_block_bio_remap(bio->bi_disk->queue, bio,
 				      disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
-		ret = direct_make_request(bio);
+		ret = generic_make_request(bio);
 	} else if (nvme_available_path(head)) {
 		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
 
-- 
2.27.0

