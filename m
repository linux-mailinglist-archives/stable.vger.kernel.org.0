Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9246B449B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjCJOZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjCJOZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:25:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127A94DE19
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:24:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA326B8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ABAC4339B;
        Fri, 10 Mar 2023 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458273;
        bh=GJ3KZbABA+l7AWrAESMedG78EQzzgEfJdzf3o6YauBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2Avpm4OA61JpHd+RFK6KKE1jTFa08kDRkQgshqTVCrjdLeHXNX7T1V1rtt1YkvxO
         beeMj8HxiLYsQdjMulxNUDu7h7Z940XKJnAJm6geZ1giciA/tdhOLWgEtbPUavTwBg
         7k8bOuZWWxTk/YjfhqvRCAuTnQfLj7ERzIBUsWW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 190/252] scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses
Date:   Fri, 10 Mar 2023 14:39:20 +0100
Message-Id: <20230310133724.699668440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

From: Tomas Henzl <thenzl@redhat.com>

commit db95d4df71cb55506425b6e4a5f8d68e3a765b63 upstream.

Sanitize possible addl_desc_ptr out-of-bounds accesses in
ses_enclosure_data_process().

Link: https://lore.kernel.org/r/20230202162451.15346-3-thenzl@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -449,8 +449,8 @@ int ses_match_host(struct enclosure_devi
 }
 #endif  /*  0  */
 
-static void ses_process_descriptor(struct enclosure_component *ecomp,
-				   unsigned char *desc)
+static int ses_process_descriptor(struct enclosure_component *ecomp,
+				   unsigned char *desc, int max_desc_len)
 {
 	int eip = desc[0] & 0x10;
 	int invalid = desc[0] & 0x80;
@@ -461,22 +461,32 @@ static void ses_process_descriptor(struc
 	unsigned char *d;
 
 	if (invalid)
-		return;
+		return 0;
 
 	switch (proto) {
 	case SCSI_PROTOCOL_FCP:
 		if (eip) {
+			if (max_desc_len <= 7)
+				return 1;
 			d = desc + 4;
 			slot = d[3];
 		}
 		break;
 	case SCSI_PROTOCOL_SAS:
+
 		if (eip) {
+			if (max_desc_len <= 27)
+				return 1;
 			d = desc + 4;
 			slot = d[3];
 			d = desc + 8;
-		} else
+		} else {
+			if (max_desc_len <= 23)
+				return 1;
 			d = desc + 4;
+		}
+
+
 		/* only take the phy0 addr */
 		addr = (u64)d[12] << 56 |
 			(u64)d[13] << 48 |
@@ -493,6 +503,8 @@ static void ses_process_descriptor(struc
 	}
 	ecomp->slot = slot;
 	scomp->addr = addr;
+
+	return 0;
 }
 
 struct efd {
@@ -565,7 +577,7 @@ static void ses_enclosure_data_process(s
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
 	}
-	if (ses_dev->page10)
+	if (ses_dev->page10 && ses_dev->page10_len > 9)
 		addl_desc_ptr = ses_dev->page10 + 8;
 	type_ptr = ses_dev->page1_types;
 	components = 0;
@@ -573,6 +585,7 @@ static void ses_enclosure_data_process(s
 		for (j = 0; j < type_ptr[1]; j++) {
 			char *name = NULL;
 			struct enclosure_component *ecomp;
+			int max_desc_len;
 
 			if (desc_ptr) {
 				if (desc_ptr >= buf + page7_len) {
@@ -599,10 +612,14 @@ static void ses_enclosure_data_process(s
 					ecomp = &edev->component[components++];
 
 				if (!IS_ERR(ecomp)) {
-					if (addl_desc_ptr)
-						ses_process_descriptor(
-							ecomp,
-							addl_desc_ptr);
+					if (addl_desc_ptr) {
+						max_desc_len = ses_dev->page10_len -
+						    (addl_desc_ptr - ses_dev->page10);
+						if (ses_process_descriptor(ecomp,
+						    addl_desc_ptr,
+						    max_desc_len))
+							addl_desc_ptr = NULL;
+					}
 					if (create)
 						enclosure_component_register(
 							ecomp);


