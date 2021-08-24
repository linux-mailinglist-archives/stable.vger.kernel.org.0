Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6B3F651A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbhHXRK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239541AbhHXRIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:08:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1CBD61503;
        Tue, 24 Aug 2021 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824404;
        bh=5k3Tdu36gmSOCNOSiwVcIjGB3i3IKB87LRVjkrBbJC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVeRaJecfVekelv4Aihgx2LzV5+BrVI7WjqRnX6ae6qh53zQzEXTkm0v2Dg3z4Rxr
         gyITJHpiC9LNEA48IfvbAZTrWuUFtKbK0wnP2KkfhU+hgBIXChbDcuwPVjK8nmNebG
         RWMyLvx9MUlLmYvtXt2kTLTbZMQrTUAWi/Ht6I8t0Yiq8XCc4LF9hStHEAlrlNGRS8
         WkNhkBEjDrerj9DLIDyKFLRAOs6vLnmSWrgf28F65ZuN8QDmrHn1ThhfOZnsv79g7C
         ibVb4v+kTaHWPRrnL3Xo9wTCCqWhNfQuTLOJ1/XXfZE1TCwz6CqVVm2VnPGPgh33zU
         3dEDhMwIHYJdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/98] bnxt_en: Disable aRFS if running on 212 firmware
Date:   Tue, 24 Aug 2021 12:58:25 -0400
Message-Id: <20210824165908.709932-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 976e52b718c3de9077fff8f3f674afb159c57fb1 ]

212 firmware broke aRFS, so disable it.  Traffic may stop after ntuple
filters are inserted and deleted by the 212 firmware.

Fixes: ae10ae740ad2 ("bnxt_en: Add new hardware RFS mode.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 96b76b713dd8..dbd99a8fd9c9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10396,6 +10396,9 @@ static bool bnxt_rfs_supported(struct bnxt *bp)
 			return true;
 		return false;
 	}
+	/* 212 firmware is broken for aRFS */
+	if (BNXT_FW_MAJ(bp) == 212)
+		return false;
 	if (BNXT_PF(bp) && !BNXT_CHIP_TYPE_NITRO_A0(bp))
 		return true;
 	if (bp->flags & BNXT_FLAG_NEW_RSS_CAP)
-- 
2.30.2

