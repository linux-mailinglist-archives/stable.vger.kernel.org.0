Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDED541A05
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354642AbiFGV2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348606AbiFGV1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:27:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6476922873A;
        Tue,  7 Jun 2022 12:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B41EB617F5;
        Tue,  7 Jun 2022 19:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A86C36B0A;
        Tue,  7 Jun 2022 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628515;
        bh=iO2P/nvW0rLUabYC+vymgQADo7tKPff85CdUNlAwSeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v04DR4A2gJuvk7VEvoRQSyKcuhSJkK4OkcWSMdRCN1NJtgoxgKIWH9nYNMDiK67In
         t2aZEetbRxNRDOx2cEjqOGBtVYJZ4T2lAuEprF5OP6FJ2QN4dt7Zq2WcOU4d+P446g
         trRBN8fhvtz6UxqDkh+vdCahGvDBMGwW2hjEhv78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 356/879] scsi: ufs: qcom: Fix ufs_qcom_resume()
Date:   Tue,  7 Jun 2022 18:57:54 +0200
Message-Id: <20220607165013.196950844@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 586c0e567ff9..e61083d01f6e 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -641,12 +641,7 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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



