Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FC65004E6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 06:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiDNEFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 00:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiDNEFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 00:05:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B332B1F637;
        Wed, 13 Apr 2022 21:02:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso3463773pjv.0;
        Wed, 13 Apr 2022 21:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UIr5XR1mljt9mcirdtIb6/vyM/By5rKMU6biIej6ubw=;
        b=p7RjGXSeO7yQ89IB4n7p4h4ArxKekNFRIrJIuCqyAd3Dvh3WGJujDEow5ihoDJw25q
         xc3SBuk4qt7TpT4Sh94QcYkvd/7XO5nGmp75XT/V9qO4X6PkthK/bg1NjYv1MDVbGgnW
         +wu9BIJQ6HAQ2a5o+f1+pctKj5lgd7g5DHowTnldNUx2h9nnNTnEzq2NBBEUaKBYBjvb
         mjyG284p3Q0GtPC5Yw4DB9ATHqmm410+LF8P1jri4pkPlEB5VFc0rdfnjPRgAONhpoom
         5VOcobGyKMuKHS3kibA/eHCPVRYibWwi6E54Q9piJb/NKpzKbQ2r/JcpLKiZpsPNglwr
         hSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UIr5XR1mljt9mcirdtIb6/vyM/By5rKMU6biIej6ubw=;
        b=VWx+T9rTkE6yA2PrMj+yDEku0ppW3TarhwjqPMAMmA9Vqe6Svk124DqK6gIcKfaSvH
         +F+Y6CU6ya0wUWFs5d3g56yCOTUIPIN2Q/P0iGyQw3hGyMg+GmFsD1EkzPAYgOQL4rT+
         Y1fcX18ikJwGFm6uhNwf4//8pnKSSKCfHgnhOHfQHenECZYpTBwt3Tia2C5KoQ6jMPft
         oXF3mhopN7HKckv644UxKdyveQufsQ9mYaz7sSYkfN08Z3WUxcmycCOeXZXAb74LiA8o
         htGjH0qlWVliY0jgF2r+tSjiH6Gk43QZLuS/5zxTg4BDTWJYb0XKOYQHZZWT0JCdj/1p
         Tg1g==
X-Gm-Message-State: AOAM531/r+Aqfs5DIl2ybZoe4AiWFt5NuvI7KHsnARKxZXmQAyG9oqOD
        G9VASAde2lfzKsBZFiMqX8Q=
X-Google-Smtp-Source: ABdhPJzK1xyujJGBlF62EYNhg/jdmjSWDzdG8VirIOYSnajKDeT5ShSQNMgteFTZ4SSy2mP0vNMsiQ==
X-Received: by 2002:a17:90a:6d96:b0:1c9:c1de:ef2f with SMTP id a22-20020a17090a6d9600b001c9c1deef2fmr2146548pjk.210.1649908958241;
        Wed, 13 Apr 2022 21:02:38 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id w1-20020a17090ac98100b001cd4e204664sm4036731pjt.4.2022.04.13.21.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 21:02:37 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, dc395x@twibble.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [RESEND][PATCH] scsi: dc395x: fix a missing check on list iterator
Date:   Thu, 14 Apr 2022 12:02:31 +0800
Message-Id: <20220414040231.2662-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	p->target_id, p->target_lun);

The list iterator 'p' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will
lead to a invalid memory access.

To fix this bug, add an check. Use a new variable 'iter' as the
list iterator, while use the origin variable 'p' as a dedicated
pointer to point to the found element.

Cc: stable@vger.kernel.org
Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/scsi/dc395x.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index c11916b8ae00..bbc03190a6f2 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3588,10 +3588,19 @@ static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
 #endif
 	if (dcb->target_lun != 0) {
 		/* Copy settings */
-		struct DeviceCtlBlk *p;
-		list_for_each_entry(p, &acb->dcb_list, list)
-			if (p->target_id == dcb->target_id)
+		struct DeviceCtlBlk *p = NULL, *iter;
+
+		list_for_each_entry(iter, &acb->dcb_list, list)
+			if (iter->target_id == dcb->target_id) {
+				p = iter;
 				break;
+			}
+
+		if (!p) {
+			kfree(dcb);
+			return NULL;
+		}
+
 		dprintkdbg(DBG_1, 
 		       "device_alloc: <%02i-%i> copy from <%02i-%i>\n",
 		       dcb->target_id, dcb->target_lun,
-- 
2.17.1

