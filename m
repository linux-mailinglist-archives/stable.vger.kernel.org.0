Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9922205E05
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389237AbgFWUTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbgFWUTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD582073E;
        Tue, 23 Jun 2020 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943547;
        bh=KbUzAb8cDH6d2UsVb9qiestvlu8+ifKjZfacHpb5n4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2R/m1Ygw3k3bcQqb/fxkq1/g68qvomlbGfKYoN1/rgTnSqvLo5+V5TUY4qm8Es24
         slkNEeHkq9KbvMBORDAr1D5+1CMNiZA+wG/+duAotl6HWVZs/2XSylnbWnJb7mpAkb
         Gf3zyaBgZG7NE9OFjDxmps/lcturkZcDb1/y/lBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 404/477] scsi: ufs-bsg: Fix runtime PM imbalance on error
Date:   Tue, 23 Jun 2020 21:56:41 +0200
Message-Id: <20200623195426.628417988@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a1e17eb03e69bb61bd1b1a14610436b7b9be12d9 ]

When ufs_bsg_alloc_desc_buffer() returns an error code, a pairing runtime
PM usage counter decrement is needed to keep the counter balanced.

Link: https://lore.kernel.org/r/20200522045932.31795-1-dinghao.liu@zju.edu.cn
Fixes: 74e5e468b664 (scsi: ufs-bsg: Wake the device before sending raw upiu commands)
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 53dd87628cbe4..516a7f573942f 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -106,8 +106,10 @@ static int ufs_bsg_request(struct bsg_job *job)
 		desc_op = bsg_request->upiu_req.qr.opcode;
 		ret = ufs_bsg_alloc_desc_buffer(hba, job, &desc_buff,
 						&desc_len, desc_op);
-		if (ret)
+		if (ret) {
+			pm_runtime_put_sync(hba->dev);
 			goto out;
+		}
 
 		/* fall through */
 	case UPIU_TRANSACTION_NOP_OUT:
-- 
2.25.1



