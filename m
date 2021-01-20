Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A302FC98C
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbhATC2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbhATB2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19C323139;
        Wed, 20 Jan 2021 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105978;
        bh=AZGLt3KmKZrVdXCGw2heQIM/ihKzET7N54NragBTGrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvRyVqV+RHZR0oFtnPexeGLb5Ijbz7YsSlsS8yh0DQHoKDLEN+W6dOQ/UoYpdQ9qR
         N1i5vkagv+eO5IqSoTG98xX2Jqs2kgZKKpNDhRLKOEoiBuN11G3fgA/MGD8DFyrbue
         LBOQcN7wUtDd3TKe20OKR/RJep7e3qTRstE1u5I0abpocGLA1VPGickIRj+icWlbMt
         GvZl/QJLGw4URE6AQchrlHnQL++E0NOLkxRwdt6LBSfxpz302m5UyXQxC3zcvcqRuF
         AwisvN3cDOwlwIFddXQQTB5DxsyYpFHffA3LEWuqHzje3sS1CGHGqHelnEajKXwNXU
         YXIHJsA/7VduA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/45] scsi: scsi_debug: Fix memleak in scsi_debug_init()
Date:   Tue, 19 Jan 2021 20:25:29 -0500
Message-Id: <20210120012602.769683-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 3b01d7ea4dae907d34fa0eeb3f17bacd714c6d0c ]

When sdeb_zbc_model does not match BLK_ZONED_NONE, BLK_ZONED_HA or
BLK_ZONED_HM, we should free sdebug_q_arr to prevent memleak. Also there is
no need to execute sdebug_erase_store() on failure of sdeb_zbc_model_str().

Link: https://lore.kernel.org/r/20201226061503.20050-1-dinghao.liu@zju.edu.cn
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24c0f7ec03511..4a08c450b756f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6740,7 +6740,7 @@ static int __init scsi_debug_init(void)
 		k = sdeb_zbc_model_str(sdeb_zbc_model_s);
 		if (k < 0) {
 			ret = k;
-			goto free_vm;
+			goto free_q_arr;
 		}
 		sdeb_zbc_model = k;
 		switch (sdeb_zbc_model) {
@@ -6753,7 +6753,8 @@ static int __init scsi_debug_init(void)
 			break;
 		default:
 			pr_err("Invalid ZBC model\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_q_arr;
 		}
 	}
 	if (sdeb_zbc_model != BLK_ZONED_NONE) {
-- 
2.27.0

