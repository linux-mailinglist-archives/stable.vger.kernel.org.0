Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03086499579
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441943AbiAXUw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391328AbiAXUrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1FD260B18;
        Mon, 24 Jan 2022 20:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722DBC340E5;
        Mon, 24 Jan 2022 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057244;
        bh=mGfUd3HAafgw69SmJ/VHmCTthCgBZVr9YmGbS1ZMPp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phBst9kyycBfjG9EjAevd7vnTwA+FUR9FfHkOsJztGTGc+W9GwKmgnR7EQz2xdNvv
         3UrLMhlNKKz2rdnvvDJQ33aSlFd704/2HxMmQgwJSwXGsxNK1Uq1Or76Tw7I59uT6P
         7B2NT/bZjAPSaILdk1XR2SRtDfKgQr6HRMhCn3Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 747/846] scsi: ufs: ufs-mediatek: Fix error checking in ufs_mtk_init_va09_pwr_ctrl()
Date:   Mon, 24 Jan 2022 19:44:24 +0100
Message-Id: <20220124184126.749169560@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 3ba880a12df5aa4488c18281701b5b1bc3d4531a upstream.

The function regulator_get() returns an error pointer. Use IS_ERR() to
validate the return value.

Link: https://lore.kernel.org/r/20211222070930.9449-1-linmq006@gmail.com
Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-mediatek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -501,7 +501,7 @@ static void ufs_mtk_init_va09_pwr_ctrl(s
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	host->reg_va09 = regulator_get(hba->dev, "va09");
-	if (!host->reg_va09)
+	if (IS_ERR(host->reg_va09))
 		dev_info(hba->dev, "failed to get va09");
 	else
 		host->caps |= UFS_MTK_CAP_VA09_PWR_CTRL;


