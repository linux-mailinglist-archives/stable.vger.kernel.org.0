Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4796699A01
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390745AbfHVRJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390726AbfHVRJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:21 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFE92341E;
        Thu, 22 Aug 2019 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493760;
        bh=sVSvY0EcxvdjzECryodqnKsV/E68UaqplmGCkJsmK7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFkL2nu/rzwMcLEdzkSiuXmPziUvwi9tCYC5+HXNJI8sD27z2va54Yz0dXdo2RE9C
         W1kHPa6//BOvW2KNI92ocWOkkRujDzJj25wdqDYL6N4nz7wi2i9gKh4GOh0TxE4uWX
         4R/EFyQ1M+eHiJzjpM6Yh3lzjcQinjxj7YNQlMcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 123/135] bnxt_en: Use correct src_fid to determine direction of the flow
Date:   Thu, 22 Aug 2019 13:07:59 -0400
Message-Id: <20190822170811.13303-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>

[ Upstream commit 685ec6a81bb0d47faf1dba49437d5bdaede2733d ]

Direction of the flow is determined using src_fid. For an RX flow,
src_fid is PF's fid and for TX flow, src_fid is VF's fid. Direction
of the flow must be specified, when getting statistics for that flow.
Currently, for DECAP flow, direction is determined incorrectly, i.e.,
direction is initialized as TX for DECAP flow, instead of RX. Because
of which, stats are not reported for this DECAP flow, though it is
offloaded and there is traffic for that flow, resulting in flow age out.

This patch fixes the problem by determining the DECAP flow's direction
using correct fid.  Set the flow direction in all cases for consistency
even if 64-bit flow handle is not used.

Fixes: abd43a13525d ("bnxt_en: Support for 64-bit flow handle.")
Signed-off-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 44d6c5743fb90..a25ed190b5b2e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1285,9 +1285,7 @@ static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
 		goto free_node;
 
 	bnxt_tc_set_src_fid(bp, flow, src_fid);
-
-	if (bp->fw_cap & BNXT_FW_CAP_OVS_64BIT_HANDLE)
-		bnxt_tc_set_flow_dir(bp, flow, src_fid);
+	bnxt_tc_set_flow_dir(bp, flow, flow->src_fid);
 
 	if (!bnxt_tc_can_offload(bp, flow)) {
 		rc = -EOPNOTSUPP;
-- 
2.20.1

