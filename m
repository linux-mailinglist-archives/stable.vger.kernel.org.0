Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860F44FCFDC
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349595AbiDLGim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350399AbiDLGh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:37:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5655A15FD6;
        Mon, 11 Apr 2022 23:34:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5441E61890;
        Tue, 12 Apr 2022 06:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558D2C385A6;
        Tue, 12 Apr 2022 06:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745273;
        bh=a+uHOV3S+wzgELtM9/J/Au4uHNeGFKSUUdWscUaa3vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kLtQpKwpjnnNSDG4D5Nw/ZOVteo67jj1/gUifgCEjDfNFoMiuhtptnr4d95kisda
         hTVuO+MssjQrmyIiGHZD1q5uEZ4oInIpa03zmI3PA6nXNSaw3TJObiYw1lhHdesQod
         GuKZ+fGoBM/zsplUEq0yypHRFqJyTxzaL3aI96kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/171] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Tue, 12 Apr 2022 08:28:51 +0200
Message-Id: <20220412062929.046626942@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
index b5e60553acdc..a10c6f6b6f25 100644
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



