Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96EF6D481F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjDCO0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjDCO0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:26:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3828E312BE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:25:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDA9661D96
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7BDC433D2;
        Mon,  3 Apr 2023 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531954;
        bh=vLPdEk4Fjw1BwPXpeXL7Y2+eIf5Xwbn9TjCRARSDY0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlX58qycLDaIwgdJqW2weqio5CRMU42nP4b53vswnnRVSnftXUWXPdg94ezFcZh/O
         Dq3jhB3DzEoVQ83gAgT82+NK3isf6y6entJS9mqZibe21+HZ7nQEoXA6vZ9+FhsqYu
         wGXBDUprZfcs1WrfSAf/o8q4zxEL5njpUAisoRb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kang Chen <void0red@gmail.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/173] scsi: hisi_sas: Check devm_add_action() return value
Date:   Mon,  3 Apr 2023 16:08:05 +0200
Message-Id: <20230403140416.702549507@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index cd41dc061d874..65971bd80186b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2402,8 +2402,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-	return 0;
+	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
-- 
2.39.2



