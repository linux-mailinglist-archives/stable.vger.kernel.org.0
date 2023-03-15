Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E426BB194
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjCOM2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjCOM20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369959BE31
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26083B81E0B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBF6C433D2;
        Wed, 15 Mar 2023 12:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883247;
        bh=wm3ypF0qMEkAA8tcumtItBatSLuz1Rq8EI2v3pXXSOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQyAcQB9NFmFjO8gvjSpK+R7rG2csgnzuVx48WBOfWfSqLGSF4Yss9m1nugZi/qZQ
         rN/YRWIidnBgXTwfo59f0Nu76oU9l9hxjGtWsutGgTwYqfV6WQnSDLAmC5RpNFVKY2
         mFc77esnbhh4qz4Lngo4daWioIQZ28V966cSENnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/145] scsi: megaraid_sas: Update max supported LD IDs to 240
Date:   Wed, 15 Mar 2023 13:12:16 +0100
Message-Id: <20230315115741.335086509@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit bfa659177dcba48cf13f2bd88c1972f12a60bf1c ]

The firmware only supports Logical Disk IDs up to 240 and LD ID 255 (0xFF)
is reserved for deleted LDs. However, in some cases, firmware was assigning
LD ID 254 (0xFE) to deleted LDs and this was causing the driver to mark the
wrong disk as deleted. This in turn caused the wrong disk device to be
taken offline by the SCSI midlayer.

To address this issue, limit the LD ID range from 255 to 240. This ensures
the deleted LD ID is properly identified and removed by the driver without
accidently deleting any valid LDs.

Fixes: ae6874ba4b43 ("scsi: megaraid_sas: Early detection of VD deletion through RaidMap update")
Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Link: https://lore.kernel.org/r/20230302105342.34933-2-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas.h    | 2 ++
 drivers/scsi/megaraid/megaraid_sas_fp.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 650210d2abb4d..02d7ab119f806 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1517,6 +1517,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 
+#define MEGASAS_MAX_SUPPORTED_LD_IDS		240
+
 #define MEGASAS_MAX_SECTORS                    (2*1024)
 #define MEGASAS_MAX_SECTORS_IEEE		(2*128)
 #define MEGASAS_DBG_LVL				1
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 83f69c33b01a9..ec10d35b4685a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -358,7 +358,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 		ld = MR_TargetIdToLdGet(i, drv_map);
 
 		/* For non existing VDs, iterate to next VD*/
-		if (ld >= (MAX_LOGICAL_DRIVES_EXT - 1))
+		if (ld >= MEGASAS_MAX_SUPPORTED_LD_IDS)
 			continue;
 
 		raid = MR_LdRaidGet(ld, drv_map);
-- 
2.39.2



