Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D321B49A5D9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371171AbiAYAHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363495AbiAXXoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:44:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17864C0FE687;
        Mon, 24 Jan 2022 13:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D41FBB8121C;
        Mon, 24 Jan 2022 21:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBAC340E4;
        Mon, 24 Jan 2022 21:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060360;
        bh=cg2dTilaFyJIJO06u5dnZECifYEUV5gg6BwU7cPzgHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zg7GN0UHCrQlsEqRSOHlv4qjZHLxyi2ec757OTfymuRcm30t4efvYEkaFVfCVLJ36
         LGAsjQU2NHvStXwQCUG8s+M41ptqtuiO6+PtQL1zT3zkduUhNDKzWDjpR8BEC4elwc
         c7MuUIHwPQdCioQZsy7eXcBzTwXaWk7ckuL/MSzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0922/1039] scsi: ufs: ufs-mediatek: Fix error checking in ufs_mtk_init_va09_pwr_ctrl()
Date:   Mon, 24 Jan 2022 19:45:11 +0100
Message-Id: <20220124184156.293502487@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -557,7 +557,7 @@ static void ufs_mtk_init_va09_pwr_ctrl(s
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	host->reg_va09 = regulator_get(hba->dev, "va09");
-	if (!host->reg_va09)
+	if (IS_ERR(host->reg_va09))
 		dev_info(hba->dev, "failed to get va09");
 	else
 		host->caps |= UFS_MTK_CAP_VA09_PWR_CTRL;


