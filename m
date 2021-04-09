Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D57359A89
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhDIJ7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhDIJ6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 135606120C;
        Fri,  9 Apr 2021 09:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962278;
        bh=XshjBLknayHbHFmkAvURjiRedqLlrTg93sVjlQjzWEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p67aLcZeq7P9MoHtNeKX0VmHLo+h4jUMGk5lHmolvlKDnCdETLu+OXlPTcUU7o30d
         WxOsexwFTRBSM+JVDoz90IoWQmGb+2rBHYfm/qmrYZfxvy77uzj80T9kpVZH97U4ix
         X0TVpo952ZqZKpPPBYkfbVo8qaILC/4PmhkbjoSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 5.4 21/23] nvme-mpath: replace direct_make_request with generic_make_request
Date:   Fri,  9 Apr 2021 11:53:51 +0200
Message-Id: <20210409095303.569029742@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
References: <20210409095302.894568462@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/multipath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -330,7 +330,7 @@ static blk_qc_t nvme_ns_head_make_reques
 		trace_block_bio_remap(bio->bi_disk->queue, bio,
 				      disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
-		ret = direct_make_request(bio);
+		ret = generic_make_request(bio);
 	} else if (nvme_available_path(head)) {
 		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
 


