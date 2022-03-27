Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE94E8627
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiC0GBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiC0GBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:01:06 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0169EBF70;
        Sat, 26 Mar 2022 22:59:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mp11-20020a17090b190b00b001c79aa8fac4so6604932pjb.0;
        Sat, 26 Mar 2022 22:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UIr5XR1mljt9mcirdtIb6/vyM/By5rKMU6biIej6ubw=;
        b=Edr0nFKJKvzF9XTVGsvfUM0dS77sF6JlW/LCPvDAwtY3N6j8AB7STprRcOqbHRfUiI
         vO+7X9nIxwHq5BCeDj6DRKQPDi4CYd48KFKvEjf2Dow16O1GewPLpajaUM/qoxtE7VSx
         DYma1a/JR+yfPSnYGQdm3yTu3q8cmX1jv85g9A2WaR2iru1ItHfDazYWefkjdr7TpvYp
         /Qi/hUA4GLGvyDNP1mQh2hvGvbRrMu/5MZ/qRHzK/o+84Aygfi4VpEKPACnM8MQWDcEV
         Lr44roNaPJE5Y0aJWyKadsllU7YuhzkraQ9csQ3djriExnVe1UA4j72kCPih2dJFuEul
         J7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UIr5XR1mljt9mcirdtIb6/vyM/By5rKMU6biIej6ubw=;
        b=pd2g4YT1yrESQE2hxB1v3CvKTLJWIbR6KKSjUKCgNOFItrPqJihIURVAZ/4kW/JwpG
         DU44lzA3gg36uS98OTqh+SEQ4vKLwo4dYUxA62lDkkGvMW2Zu2JRu5engiMdiUVaqhta
         U3lSs9GU3LndR+gN6A0LsLWr9qt75em6JHgya1XU0cO7nol9Y/FfVjVu8XjS3gDqF5uZ
         l2swq+knvXXRzOF+Q2oF7zsTc/jZAiflg3X7M8Y21v95XxinYNSIKyPretjr5hn25IY0
         vLN15V6KXLAHB/Leoc0wV4NS5OVr+F2Kzqf9kFzJbkiagySyxs61cmDu6sYWeCaEvRZr
         QJgw==
X-Gm-Message-State: AOAM5310hid1ciqLGVwekf8MevbY/1PbKi1vva8x03mhUOYflaZ/4sGF
        x8Eg1SKNBqe+EwPUcEYCL4M=
X-Google-Smtp-Source: ABdhPJzRSR1AOVYeHiHJTWcKS5PD6CkACVDXhJj6/Uo7MSt0tneGJfN70cJTrxbHsAKBcxRGFaiMaQ==
X-Received: by 2002:a17:90b:4f4d:b0:1c7:467c:e24e with SMTP id pj13-20020a17090b4f4d00b001c7467ce24emr22237855pjb.102.1648360768622;
        Sat, 26 Mar 2022 22:59:28 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm9337256pgn.72.2022.03.26.22.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:59:28 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     oliver@neukum.org
Cc:     aliakc@web.de, lenehan@twibble.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] scsi: dc395x: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 13:59:21 +0800
Message-Id: <20220327055921.4191-1-xiam0nd.tong@gmail.com>
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

