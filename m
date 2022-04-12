Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA024FDB2B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355821AbiDLH3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354486AbiDLHR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C727413F89;
        Mon, 11 Apr 2022 23:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CAC615B8;
        Tue, 12 Apr 2022 06:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3909C385A6;
        Tue, 12 Apr 2022 06:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746762;
        bh=yi7wTzc1JGwip0XrlP6gry2kJYuP98mfD52o/JlFv/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCUdaLQDf2Ru2t306cUNNJlQ6tcng05MNWuUzvzeoe+83akyp5SPUwlg400OKCFjN
         Q3XmccJQ6mJMmRg5H8+VrS1Qrpyx99BkfF+7u/aYHCKfOD4JpLm4Igj0akKjamgPYz
         o2sfpR0wlIwOA6pO5/1S5O6Syboj7rR6qvSB0lEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 070/285] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Tue, 12 Apr 2022 08:28:47 +0200
Message-Id: <20220412062945.688323155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 3762d8f6edcdb03994c919f9487fd6d336c06561 ]

The declaration of the local variable destination1 in pm80xx_pci_mem_copy()
as a pointer to a u32 results in the sparse warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype]
    got restricted __le32 [usertype]

Furthermore, the destination" argument of pm80xx_pci_mem_copy() is wrongly
declared with the const attribute.

Fix both problems by changing the type of the "destination" argument to
"__le32 *" and use this argument directly inside the pm80xx_pci_mem_copy()
function, thus removing the need for the destination1 local variable.

Link: https://lore.kernel.org/r/20220220031810.738362-6-damien.lemoal@opensource.wdc.com
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 48b0154211c7..00498e3660e1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -66,18 +66,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 }
 
 static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
-				const void *destination,
+				__le32 *destination,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 = (u32 *)destination;
 
-	for (index = 0; index < dw_count; index += 4, destination1++) {
+	for (index = 0; index < dw_count; index += 4, destination++) {
 		offset = (soffset + index);
 		if (offset < (64 * 1024)) {
 			value = pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =  cpu_to_le32(value);
+			*destination = cpu_to_le32(value);
 		}
 	}
 	return;
-- 
2.35.1



