Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736093F64FA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhHXRJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238861AbhHXRHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9F161A07;
        Tue, 24 Aug 2021 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824399;
        bh=muyIKomV58ypttprz4sDMH/VDekGp6TxEGG0wNCA/eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAx1nJVSp4OdWCb7Eom88C2BrpXvZkl7EdkG/VJGsi9V9E93/09DFGZ5Gx7ci6YwT
         DVH27BSIT5PvfWbMmFqEiD7ExGQSu+0VqN/miHbtoGyygS5mD2K+xyVEyTtavZhJE9
         qtZ8TG9w5loVkjh3POskL1h6wTTOOc0VcmHEiUutgXkQCHfk/FUsLR8UClRTfIglcs
         U6kKO0nLdskePk8UtjQIVO39ZskLqcTXvsckcAYpNmdATeqkEu12sRkfR6dS3HZMWM
         X2EW1CYoH5bComNW0y4lghcd+eKfM4XUyhqzJvLT5P8od0S1A+KAuicF+aWXemBIOO
         ufx30MwXwV0tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/98] bnxt: disable napi before canceling DIM
Date:   Tue, 24 Aug 2021 12:58:20 -0400
Message-Id: <20210824165908.709932-51-sashal@kernel.org>
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
index 65e41612b9da..621346656af3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8855,10 +8855,9 @@ static void bnxt_disable_napi(struct bnxt *bp)
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

