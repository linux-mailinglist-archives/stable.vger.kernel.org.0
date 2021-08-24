Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47E93F65C0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbhHXRQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240161AbhHXROZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D86A361A87;
        Tue, 24 Aug 2021 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824499;
        bh=TFxNky5VT8pwnV8qlMdLhGenwvHr3QJoIs1i0L9ZtI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abTd/YMhRz2BycZeaPYpEeYB57N2LhIYmpWckiv8lKX/q33wiQAN5ymb6BAave6Ey
         OevzrivT25BRiUu0+CzSsJLXpn7dRBIS3+jF2oDs9lQES0G1XvZCQW92m0nEftdzD5
         c/E0gtTbkP27UH7Hh8RSlI13SNj3elTAoMyb8dUOqPhg3dF6Tan1ODiL73zoNBd6h0
         2H7VvZiiIumO1CwfH5YuRkEDxKBBCMFMmae7XyOcX31DOSUh9UVfZQGehK7fDd0ukR
         YIxpMXQbgDZJylFNJ1lxHk6/A8FuCKDU3LtlM5Va55xNsHOjV2W0Kr3OyanIwmDHPR
         C0hdBc364w7og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/61] bnxt: disable napi before canceling DIM
Date:   Tue, 24 Aug 2021 13:00:37 -0400
Message-Id: <20210824170106.710221-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 01cca6b9330ac7460de44eeeb3a0607f8aae69ff ]

napi schedules DIM, napi has to be disabled first,
then DIM canceled.

Noticed while reading the code.

Fixes: 0bc0b97fca73 ("bnxt_en: cleanup DIM work on device shutdown")
Fixes: 6a8788f25625 ("bnxt_en: add support for software dynamic interrupt moderation")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8111aefb2411..1b5839ad97b6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8346,10 +8346,9 @@ static void bnxt_disable_napi(struct bnxt *bp)
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_cp_ring_info *cpr = &bp->bnapi[i]->cp_ring;
 
+		napi_disable(&bp->bnapi[i]->napi);
 		if (bp->bnapi[i]->rx_ring)
 			cancel_work_sync(&cpr->dim.work);
-
-		napi_disable(&bp->bnapi[i]->napi);
 	}
 }
 
-- 
2.30.2

