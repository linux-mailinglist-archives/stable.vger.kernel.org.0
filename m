Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6A36CC43B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjC1PBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbjC1PB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3048EB71
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38156617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A41C433EF;
        Tue, 28 Mar 2023 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015667;
        bh=F4cf46G1SzMAmP/1mVA/MZTSif0m74J5A6XC5SLL+R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLcb80kFODLhoebSdH1FiS7uR8ojWiVOZfUdg18yojJMBlIyBIeuqv+gvfz1Qal1z
         YifbNCwal6g0wE9HMUF5ZI3zs/YCdpJjWfD/lHPkZG6jUGF21AX80JgmL3kAaX3se0
         AjUQrMRRUgHhEJTI6/gTP4OQsJ6OEa5OaaK0m+G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kang Chen <void0red@gmail.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/224] scsi: hisi_sas: Check devm_add_action() return value
Date:   Tue, 28 Mar 2023 16:42:08 +0200
Message-Id: <20230328142622.878810134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 06d1a90de60208054cca15ef200138cfdbb642a9 ]

In case devm_add_action() fails, check it in the caller of
interrupt_preinit_v3_hw().

Link: https://lore.kernel.org/r/20230227031030.893324-1-void0red@gmail.com
Signed-off-by: Kang Chen <void0red@gmail.com>
Acked-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d56b4bfd27678..620dcefe7b6f4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2448,8 +2448,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-	return 0;
+	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
-- 
2.39.2



