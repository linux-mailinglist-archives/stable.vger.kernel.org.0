Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00649205D82
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbgFWUOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388113AbgFWUNz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6163206C3;
        Tue, 23 Jun 2020 20:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943235;
        bh=c+CPTIXmgbxyoeBfAdA5ECROgM9KWx3thblrex/BmUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfJktWRLJ/BW6Pqjdm2djNcQKtUac5PUWQjSHeu94+HWXuXceKoWhrtMf0d9dc6y6
         S3Nh6NQQ5ztNDUKFbzEqh0xcokYGJh1l2/2gc+/M+vS3/3U4pEeZFj9GBHjgyZv2ng
         yW0D8vn49u6uJEhSWUEwYa8lXODB46uZ1wSPZfac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 313/477] scsi: ufs: Dont update urgent bkops level when toggling auto bkops
Date:   Tue, 23 Jun 2020 21:55:10 +0200
Message-Id: <20200623195422.333364799@linuxfoundation.org>
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

From: Can Guo <cang@codeaurora.org>

[ Upstream commit be32acff43800c87dc5c707f5d47cc607b76b653 ]

Urgent bkops level is used to compare against actual bkops status read from
UFS device. Urgent bkops level is set during initialization and might be
updated in exception event handler during runtime. But it should not be
updated to the actual bkops status every time when auto bkops is toggled.
Otherwise, if urgent bkops level is updated to 0, auto bkops shall always
be kept enabled.

Link: https://lore.kernel.org/r/1590632686-17866-1-git-send-email-cang@codeaurora.org
Fixes: 24366c2afbb0 ("scsi: ufs: Recheck bkops level if bkops is disabled")
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4bac..52740b60d7869 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5098,7 +5098,6 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
 		err = ufshcd_enable_auto_bkops(hba);
 	else
 		err = ufshcd_disable_auto_bkops(hba);
-	hba->urgent_bkops_lvl = curr_status;
 out:
 	return err;
 }
-- 
2.25.1



