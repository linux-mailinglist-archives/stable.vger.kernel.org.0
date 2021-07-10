Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3AF3C2D2C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhGJCWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhGJCVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13204613EB;
        Sat, 10 Jul 2021 02:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883533;
        bh=5uGHoFbxC057inXKnuUYBivDyaNYMVwoUbIjXcXUV6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZWzc+vUO8ls2moF+sZozFVEUqELmr9YGA/7N/0/oH0FgwisZmgh3TcR3M0UKvVHj
         QLv9uYqX+XRS18qaXzyfwO/wStezn5oALjd2pSWYTjQXxKUOp836mi6R1QnwYR9zrp
         DHp/vbJCxEc2bSLWM72+2UOUo7OobUI7qLfy0bxtwG+7AgMm7TeEB8I4YIJf/5S3Fa
         OeyBJYQ+iOoMSQGzPgtiWmyjBzNrwMp5AgJfqf8r93hyim97VznoS+PxebyXevKvJA
         SlwZXr0Mm4FLxX34LG/JUlYXQPdrIBDdAME1aWR+w6zHIJZXA0LR29dW49WZZpdXq2
         4PHcaXPUSTbhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 047/114] scsi: qedi: Fix null ref during abort handling
Date:   Fri,  9 Jul 2021 22:16:41 -0400
Message-Id: <20210710021748.3167666-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5777b7f0f03ce49372203b6521631f62f2810c8f ]

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Link: https://lore.kernel.org/r/20210525181821.7617-20-michael.christie@oracle.com
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.30.2

