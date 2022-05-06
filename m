Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0CB51D7ED
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 14:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392151AbiEFMgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 08:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392096AbiEFMgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 08:36:41 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CAF6A01B;
        Fri,  6 May 2022 05:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1651840345; x=1683376345;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fzQFkq/K6iZlQWPOHYF8YT4ikih/eSX7EA3Eb9gwWAI=;
  b=Vnsvd3o7IwJjQ2AP6U7huYyGKnDkF11yOmFDEZKRfu9i/z7L7TUWnsgv
   K0jYJA8kBjlRQ83ZXNJ24ketB4tYLq/An8n7/yux17zpf5wyY/JFFZixe
   aaepy06pQrEWQ4TacoQk85ZILCCc72+ME8txGgFk0OLYBG3urhRRRKe2U
   I=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="293244886"
X-IronPort-AV: E=Sophos;i="5.91,203,1647298800"; 
   d="scan'208";a="293244886"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 14:32:22 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Fri,  6 May 2022 14:32:21 +0200 (CEST)
Received: from MUCSE818.infineon.com (172.23.29.44) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 6 May 2022
 14:32:21 +0200
Received: from smaha-lin-dev01.agb.infineon.com (172.23.8.247) by
 MUCSE818.infineon.com (172.23.29.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 6 May 2022 14:32:20 +0200
From:   Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
To:     <jarkko@kernel.org>, <linux-integrity@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Marten.Lindahl@axis.com>, <martenli@axis.com>, <jgg@ziepe.ca>,
        <jsnitsel@redhat.com>, <nayna@linux.vnet.ibm.com>,
        <johannes.holland@infineon.com>, <peterhuewe@gmx.de>,
        Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] tpm: Fix buffer access in tpm2_get_tpm_pt()
Date:   Fri, 6 May 2022 14:31:46 +0200
Message-ID: <20220506123145.229058-1-stefan.mahnke-hartmann@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE801.infineon.com (172.23.29.27) To
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
requesting a capability, the TPM in Field Upgrade mode may return a
zero length list.
Check the property count in tpm2_get_tpm_pt().

Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
---
 drivers/char/tpm/tpm2-cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 4704fa553098..e62a644ce26b 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -400,7 +400,10 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	if (!rc) {
 		out = (struct tpm2_get_cap_out *)
 			&buf.data[TPM_HEADER_SIZE];
-		*value = be32_to_cpu(out->value);
+		if (be32_to_cpu(out->property_cnt) > 0)
+			*value = be32_to_cpu(out->value);
+		else
+			rc = -ENODATA;
 	}
 	tpm_buf_destroy(&buf);
 	return rc;
-- 
2.25.1

