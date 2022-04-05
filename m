Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2EF4F3BFB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382237AbiDEMDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358079AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F98560D86;
        Tue,  5 Apr 2022 03:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9EC0B81B7A;
        Tue,  5 Apr 2022 10:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BDAC385A1;
        Tue,  5 Apr 2022 10:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153695;
        bh=sr3LZrPOkIdDnxYBshlhTqQx6kFEt1lc9zaoiMvEjD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQ5LSClGORKCj85WF70HNmHQQelK/hR2ZW8JUd/pbzugezGQYjGOnKO61b1ybRspG
         92zFDQ/sQKhnsxhfnDVz+HYtcdJkTkRHFtQJ2xGFqXlPTS/ihLyTZr77yKkInQ6rKA
         cP97WBN7TzxLR8SQdnhQnREeK7yS25hLkleSkQBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/599] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
Date:   Tue,  5 Apr 2022 09:30:07 +0200
Message-Id: <20220405070308.147635068@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

[ Upstream commit f8b12dfb476dad38ce755aaf5e2df46f06f1822e ]

All fields of the kek_mgmt_req structure have the type __le32. So make sure
to use cpu_to_le32() to initialize them. This suppresses the sparse
warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] new_curidx_ksop
   got int

Link: https://lore.kernel.org/r/20220220031810.738362-10-damien.lemoal@opensource.wdc.com
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index f9736e02010d..ac6334f8d791 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1403,12 +1403,13 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 	/* Currently only one key is used. New KEK index is 1.
 	 * Current KEK index is 1. Store KEK to NVRAM is 1.
 	 */
-	payload.new_curidx_ksop = ((1 << 24) | (1 << 16) | (1 << 8) |
-					KEK_MGMT_SUBOP_KEYCARDUPDATE);
+	payload.new_curidx_ksop =
+		cpu_to_le32(((1 << 24) | (1 << 16) | (1 << 8) |
+			     KEK_MGMT_SUBOP_KEYCARDUPDATE));
 
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Saving Encryption info to flash. payload 0x%x\n",
-		   payload.new_curidx_ksop);
+		   le32_to_cpu(payload.new_curidx_ksop));
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
-- 
2.34.1



