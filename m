Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765B9F7E61
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfKKSpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729362AbfKKSpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:45:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3266820659;
        Mon, 11 Nov 2019 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497947;
        bh=bzp0MO4stnUNNQs3nttCLb6EdBmNW3XoxLsUxuYDDEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bI+FnEq8T2fwNUJAbo45bfzeopKHcJiLeYdP6p0oTtZ9N4oOq06r8k2R0w6TjI5sK
         cKYjld2PgJw82Hqt6IRCEuFcuFJTWik1efssTk2nRx2aQi3rx80SIoCThoHg/zWi9N
         ToiHqZtqtY9is1aPjSKVJpwoLAFUJ21bHXNcmLYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/125] nvme-multipath: fix possible io hang after ctrl reconnect
Date:   Mon, 11 Nov 2019 19:29:03 +0100
Message-Id: <20191111181453.821670586@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit af8fd0424713a2adb812d10d55e86718152cf656 ]

The following scenario results in an IO hang:
1) ctrl completes a request with NVME_SC_ANA_TRANSITION.
   NVME_NS_ANA_PENDING bit in ns->flags is set and ana_work is triggered.
2) ana_work: nvme_read_ana_log() tries to get the ANA log page from the ctrl.
   This fails because ctrl disconnects.
   Therefore nvme_update_ns_ana_state() is not called
   and NVME_NS_ANA_PENDING bit in ns->flags is not cleared.
3) ctrl reconnects: nvme_mpath_init(ctrl,...) calls
   nvme_read_ana_log(ctrl, groups_only=true).
   However, nvme_update_ana_state() does not update namespaces
   because nr_nsids = 0 (due to groups_only mode).
4) scan_work calls nvme_validate_ns() finds the ns and re-validates OK.

Result:
The ctrl is now live but NVME_NS_ANA_PENDING bit in ns->flags is still set.
Consequently ctrl will never be considered a viable path by __nvme_find_path().
IO will hang if ctrl is the only or the last path to the namespace.

More generally, while ctrl is reconnecting, its ANA state may change.
And because nvme_mpath_init() requests ANA log in groups_only mode,
these changes are not propagated to the existing ctrl namespaces.
This may result in a mal-function or an IO hang.

Solution:
nvme_mpath_init() will nvme_read_ana_log() with groups_only set to false.
This will not harm the new ctrl case (no namespaces present),
and will make sure the ANA state of namespaces gets updated after reconnect.

Note: Another option would be for nvme_mpath_init() to invoke
nvme_parse_ana_log(..., nvme_set_ns_ana_state) for each existing namespace.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 892ef52122329..838ee58d80cda 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -575,7 +575,7 @@ int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 		goto out;
 	}
 
-	error = nvme_read_ana_log(ctrl, true);
+	error = nvme_read_ana_log(ctrl, false);
 	if (error)
 		goto out_free_ana_log_buf;
 	return 0;
-- 
2.20.1



