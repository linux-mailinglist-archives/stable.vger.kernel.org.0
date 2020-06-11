Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812E1F6BA7
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgFKPyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:54:35 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:55994 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFKPyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:54:35 -0400
Received: from moto.blr.asicdesigners.com (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05BFrs73005517;
        Thu, 11 Jun 2020 08:54:04 -0700
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Cc:     stable@vger.kernel.org, nirranjan@chelsio.com, bharat@chelsio.com,
        dakshaja@chelsio.com
Subject: [PATCH for-stable nvmet 0/6] nvme: Fix for blk_update_request IO error.
Date:   Thu, 11 Jun 2020 21:23:33 +0530
Message-Id: <20200611155339.9429-1-dakshaja@chelsio.com>
X-Mailer: git-send-email 2.18.0.232.gb7bd9486b.dirty
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The below error is seen in dmesg, while formatting the disks discovered on host.

dmesg:
        [  636.733374] blk_update_request: I/O error, dev nvme4n1, sector 0 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0

Patch 6 fixes it and there are 5 other dependent patches that also need to be 
pulled from upstream to stable, 5.4 and 4.19 branches.

Patch 1 dependent patch

Patch 2 dependent patch

Patch 3 dependent patch

Patch 4 dependent patch

Patch 5 dependent patch

Patch 6 fix patch

Thanks,
Dakshaja


Christoph Hellwig (5):
  nvmet: Cleanup discovery execute handlers
  nvmet: Introduce common execute function for get_log_page and identify
  nvmet: Introduce nvmet_dsm_len() helper
  nvmet: Remove the data_len field from the nvmet_req struct
  nvmet: Open code nvmet_req_execute()

Sagi Grimberg (1):
  nvmet: fix dsm failure when payload does not match sgl descriptor

 drivers/nvme/target/admin-cmd.c   | 128 +++++++++++++++++-------------
 drivers/nvme/target/core.c        |  23 ++++--
 drivers/nvme/target/discovery.c   |  62 +++++++--------
 drivers/nvme/target/fabrics-cmd.c |  15 +++-
 drivers/nvme/target/fc.c          |   4 +-
 drivers/nvme/target/io-cmd-bdev.c |  19 +++--
 drivers/nvme/target/io-cmd-file.c |  20 +++--
 drivers/nvme/target/loop.c        |   2 +-
 drivers/nvme/target/nvmet.h       |  11 ++-
 drivers/nvme/target/rdma.c        |   4 +-
 drivers/nvme/target/tcp.c         |   6 +-
 11 files changed, 176 insertions(+), 118 deletions(-)

-- 
2.18.0.232.gb7bd9486b.dirty

