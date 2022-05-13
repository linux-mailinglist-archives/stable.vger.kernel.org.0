Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF17526323
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbiEMNuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381023AbiEMNjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 09:39:32 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E9013CFF;
        Fri, 13 May 2022 06:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1652449165; x=1683985165;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4mi3d0qtu3W+Emy4+uUsD9l4HPVBt6DKNVl7oLxijQI=;
  b=TSKq1ObomKi8YXiUqHf22ek1A+7Qpvjn4hL9YyIysxXCntfRa/69mLXg
   kjSsQqrHJUNuMgF0Ppvf3w85hWuXHPRdeR9ckYtdAOpmY/KSjaXqT2k3h
   ByUXYJv9hJ7m9y5RPVf7a6jagLHO266kcGrkZBbVL4FYTNwADpDCmdxKq
   8=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="294595334"
X-IronPort-AV: E=Sophos;i="5.91,223,1647298800"; 
   d="scan'208";a="294595334"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:39:12 +0200
Received: from MUCSE814.infineon.com (MUCSE814.infineon.com [172.23.29.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Fri, 13 May 2022 15:39:11 +0200 (CEST)
Received: from MUCSE818.infineon.com (172.23.29.44) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 13 May
 2022 15:39:11 +0200
Received: from smaha-lin-dev01.agb.infineon.com (172.23.8.247) by
 MUCSE818.infineon.com (172.23.29.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 13 May 2022 15:39:10 +0200
From:   Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
To:     <jarkko@kernel.org>, <linux-integrity@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterhuewe@gmx.de>, <jgg@ziepe.ca>, <jsnitsel@redhat.com>,
        <nayna@linux.vnet.ibm.com>, <stefan.mahnke-hartmann@infineon.com>,
        <alexander.steffen@infineon.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] tpm: Fix buffer access in tpm2_get_tpm_pt()
Date:   Fri, 13 May 2022 15:41:51 +0200
Message-ID: <20220513134152.270442-1-stefan.mahnke-hartmann@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE813.infineon.com (172.23.29.39) To
 MUCSE818.infineon.com (172.23.29.44)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Under certain conditions uninitialized memory will be accessed.
As described by TCG Trusted Platform Module Library Specification,
rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
requesting a capability, the TPM in field upgrade mode may return a
zero length list.
Check the property count in tpm2_get_tpm_pt().

Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
---
Changelog:
 * v2:
   * Add inline comment to indicate the root cause to may access unitilized
     memory.
   * Change 'field upgrade mode' to lower case.

 drivers/char/tpm/tpm2-cmd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 4704fa553098..04a3e23a4afc 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -400,7 +400,16 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	if (!rc) {
 		out = (struct tpm2_get_cap_out *)
 			&buf.data[TPM_HEADER_SIZE];
-		*value = be32_to_cpu(out->value);
+		/*
+		 * To prevent failing boot up of some systems, Infineon TPM2.0
+		 * returns SUCCESS on TPM2_Startup in field upgrade mode. Also
+		 * the TPM2_Getcapability command returns a zero length list
+		 * in field upgrade mode.
+		 */
+		if (be32_to_cpu(out->property_cnt) > 0)
+			*value = be32_to_cpu(out->value);
+		else
+			rc = -ENODATA;
 	}
 	tpm_buf_destroy(&buf);
 	return rc;
-- 
2.25.1

