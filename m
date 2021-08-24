Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB013F63E9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbhHXQ7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhHXQ6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CCA613E6;
        Tue, 24 Aug 2021 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824225;
        bh=WtjFDEqLjqXvHkGAANdcG08wEZicgqCna4p0UVLW2oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITCBG9xpO2VbLxEbxmPUf6vvCksPeX9/2CE8rlm4/1vl/8W4OOF4LGJOimSqySEsu
         xV/YxGisChJhezqNg9jiCl0zzFEE3WQUn38VVsX2RYPt83QvBnfEL23HHA7Tvjv01v
         hT2fIT/QGuQNQmASsBPNkpOre/8GzKZKkPl9KOAX2r5bql0LOw1LQwgvyH+rKbmecW
         k/0JKtj77MuTpk1zC1LycoCoiBYYbR4rQpP+glxsEKhLO0g16QiZL4q9a2d3/Hj93i
         rUI/mN2eDC7o2tVPcurHrK5UwfOLoJwecECoEFEhULXh7Iv+o3a/86jKYw8PvnMr78
         vb4REpGMPeLVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 058/127] bnxt_en: Disable aRFS if running on 212 firmware
Date:   Tue, 24 Aug 2021 12:54:58 -0400
Message-Id: <20210824165607.709387-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index a30ded73bba1..e4c8c681a3af 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10668,6 +10668,9 @@ static bool bnxt_rfs_supported(struct bnxt *bp)
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

