Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0815302ABA
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbhAYSvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbhAYStQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65E7221E7;
        Mon, 25 Jan 2021 18:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600515;
        bh=AZGLt3KmKZrVdXCGw2heQIM/ihKzET7N54NragBTGrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYMh2N/Tuzr05OBNgeyIqlzAsxq+5TUx9a81fvD4pIGV2Ihx5SGdD5aaxUHW5aOST
         Xu+0O1t3TCXq4H8g35pGGhVcTZw6IsTlxe6ymF+lsSK8Vka0/4vJRw86uXaNrBXqJ1
         gf6OPGyY2C6ZnNKvJk/ij5vvVHL83zwPWHHy66Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/199] scsi: scsi_debug: Fix memleak in scsi_debug_init()
Date:   Mon, 25 Jan 2021 19:37:46 +0100
Message-Id: <20210125183218.115109438@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



