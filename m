Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12548540A48
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349030AbiFGST2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352134AbiFGSQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADC1DFE9;
        Tue,  7 Jun 2022 10:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F950B8233D;
        Tue,  7 Jun 2022 17:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB08C385A5;
        Tue,  7 Jun 2022 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624236;
        bh=DxFszKx2N6Ngf9HkA5IBe/+I+X4ZtA6pvkdCGaK8szY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWbptNXVz2QJPvppVqoavcKQ3RlxFR9GJuPr25mHyffm8odKCZSF87KkSm6jPrETl
         G782tVeKGLsDbmy1spIypX1HDdRq2Wi1Qz8RKPuVDC/J4H+6LQD3j/HGnhxDBLsQtp
         v5F35xfE8i9Z0Toy2iOxu6X+2XoSUeRD+yQUdEXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/667] scsi: ufs: qcom: Fix ufs_qcom_resume()
Date:   Tue,  7 Jun 2022 18:58:38 +0200
Message-Id: <20220607164942.371416807@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit bee40dc167da159ea5b939c074e1da258610a3d6 ]

Clearing hba->is_sys_suspended if ufs_qcom_resume() succeeds is wrong. That
variable must only be cleared if all actions involved in a resume succeed.
Hence remove the statement that clears hba->is_sys_suspended from
ufs_qcom_resume().

Link: https://lore.kernel.org/r/20220419225811.4127248-23-bvanassche@acm.org
Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9d9770f1db4f..c781c132d48f 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -637,12 +637,7 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			return err;
 	}
 
-	err = ufs_qcom_ice_resume(host);
-	if (err)
-		return err;
-
-	hba->is_sys_suspended = false;
-	return 0;
+	return ufs_qcom_ice_resume(host);
 }
 
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
-- 
2.35.1



