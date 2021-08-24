Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36D23F63DC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhHXQ6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236318AbhHXQ5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1DA361425;
        Tue, 24 Aug 2021 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824219;
        bh=3ufwPgDyUuRYR33x4aV6Vojx0j7Vu5YuotZIlwfrHfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLICHJzhCMLIE0m5aJhuG9BwVXAK41SWgfvZeDt/z7uAmNz9gZpiW8z4433384+Bf
         CQI1g+4u4z7PGerpAX+tkhzAyQHF3bP9jbYDZq2WmSj7d4F5Ia2cu0mG86Ep2SoGUd
         Gr2kMNvxvmNc3nD3BlEu6cAndehWUf6VUPKHEqBSVEH69fGGW6JzyhMKp3NkXMOgZk
         VZ1cLilyzlavdroIiOhDhWci2i/auZCePFatQu7PmVer620c/tNRh2xvZSfhPI9Rkq
         1Ih1fDGRpuFrA0SNT7Ffw0Rwl8jOvA0BSpwXk0oPs2xthIwKyYytAZ0HlNf5Ynka0F
         Rn7gUyFETpkkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 052/127] bnxt: disable napi before canceling DIM
Date:   Tue, 24 Aug 2021 12:54:52 -0400
Message-Id: <20210824165607.709387-53-sashal@kernel.org>
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
index d0b3be7b1c1a..17ee5c436069 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9024,10 +9024,9 @@ static void bnxt_disable_napi(struct bnxt *bp)
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

