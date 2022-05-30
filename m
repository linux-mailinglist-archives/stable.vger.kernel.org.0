Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE89C538362
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiE3OdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242490AbiE3ObO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:31:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C29EBA9F;
        Mon, 30 May 2022 06:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4549BCE1024;
        Mon, 30 May 2022 13:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7067CC3411C;
        Mon, 30 May 2022 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918760;
        bh=493NnMb0m3jXFaC9Qo/ThcPB1+4sJ7bhd1oanoqWjbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEmL5Ka13BFL8PxJxMyMRJvDnZozmtYpkVjnM6zAPl3YN2Qfb5mYgLvCTLklpqGN+
         py+vxmM6eTq9bsugxtqbV+WGahp03Wvx3WLxnPveT/qgBN+mP24GVwDvj0uwfnKUFN
         X9aTTx6HnbFpz67mfqD7nn+m21jrU/0fqv/iqy5yO8fbPuyhhQmfCM1hlgkAkNY44f
         UjzlQPWc0d5pLHGPtBgbJtghMi8tcCxERrjMMmPc3ZV4GUxGaVmIAWzIfE+sbobwvN
         3OTaWuOmCbFr87miNEDuNmVOIgOkPbxURjtK/CEAL+US1pPXdD14KOJg0XYiTgfBj1
         ZpZkhw+4FcA4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/24] scsi: megaraid: Fix error check return value of register_chrdev()
Date:   Mon, 30 May 2022 09:51:58 -0400
Message-Id: <20220530135211.1937674-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135211.1937674-1-sashal@kernel.org>
References: <20220530135211.1937674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit c5acd61dbb32b6bda0f3a354108f2b8dcb788985 ]

If major equals 0, register_chrdev() returns an error code when it fails.
This function dynamically allocates a major and returns its number on
success, so we should use "< 0" to check it instead of "!".

Link: https://lore.kernel.org/r/20220418105755.2558828-1-lv.ruyi@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 2cbfec6a7466..2f7132edcd3f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4705,7 +4705,7 @@ static int __init megaraid_init(void)
 	 * major number allocation.
 	 */
 	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
-	if (!major) {
+	if (major < 0) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char device\n");
 	}
-- 
2.35.1

