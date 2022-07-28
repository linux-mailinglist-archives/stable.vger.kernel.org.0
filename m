Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30F2584058
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiG1NuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiG1NuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:50:14 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E7B85F;
        Thu, 28 Jul 2022 06:50:11 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id r186so1600880pgr.2;
        Thu, 28 Jul 2022 06:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2Kd3bInXSJIW+jKSqBA+vZD1jT+oF/QTugtXUqpJZ0=;
        b=LQ5PauGxS4PLP7soXZO9HBsFl2ZCLmouat/prXHldjkfVCnn9pKGz3ugV1ab0gA4RH
         bGtRpxuHLd3LygBuYnyXWuTtxPl1bboNhpzDt9bZesSzw4iQ1Z7Sc4yESANvbfxyvC+i
         /OMkj2I+MM/+8NOfG6UkJ4Hoz7VPH+IFbylSaFGKo/3LDxMf1fq2+5zi55uZBQA8JeOa
         y4rG6ssd1ab1cIwTVn/NKPgbGEQlKd29nbogcudSrzd5CNezy7Y7mIEaa0bbwhsNCcY9
         yrD7oMCofwGA9vDK7qg1FsdhCTzbfS/OI85O5g/N1MPDNSOJ0UfDsLeMRlyQg67u8y6W
         NMtQ==
X-Gm-Message-State: AJIora99vWCRm7igMo6iIjKBYRrI5h+nUKZmdk78UbjbElGj4X4i+3lG
        nMSe+4tPiea6eOTxCR3waboGDFiJ/sE=
X-Google-Smtp-Source: AGRyM1uCLctDakUXd+7RIjexvhkO4LbunYpilrHiRVMcFExYoqQxaERsZK+qdv1NJIhDqhIgDOfavQ==
X-Received: by 2002:a65:6b89:0:b0:41a:69b1:8674 with SMTP id d9-20020a656b89000000b0041a69b18674mr22928614pgw.417.1659016211095;
        Thu, 28 Jul 2022 06:50:11 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902eb8800b0016cf985c0fcsm491712plg.124.2022.07.28.06.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:50:10 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        stable@vger.kernel.org, zdi-disclosures@trendmicro.com
Subject: [PATCH v2 4/5] ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT
Date:   Thu, 28 Jul 2022 22:49:45 +0900
Message-Id: <20220728134946.7603-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220728134946.7603-1-linkinjeon@kernel.org>
References: <20220728134946.7603-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

if Status is not 0 and PathLength is long,
smb_strndup_from_utf16 could make out of bound
read in smb2_tree_connnect.

This bug can lead an oops looking something like:

[ 1553.882047] BUG: KASAN: slab-out-of-bounds in smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882064] Read of size 2 at addr ffff88802c4eda04 by task kworker/0:2/42805
...
[ 1553.882095] Call Trace:
[ 1553.882098]  <TASK>
[ 1553.882101]  dump_stack_lvl+0x49/0x5f
[ 1553.882107]  print_report.cold+0x5e/0x5cf
[ 1553.882112]  ? smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882122]  kasan_report+0xaa/0x120
[ 1553.882128]  ? smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882139]  __asan_report_load_n_noabort+0xf/0x20
[ 1553.882143]  smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882155]  ? smb_strtoUTF16+0x3b0/0x3b0 [ksmbd]
[ 1553.882166]  ? __kmalloc_node+0x185/0x430
[ 1553.882171]  smb2_tree_connect+0x140/0xab0 [ksmbd]
[ 1553.882185]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[ 1553.882197]  process_one_work+0x778/0x11c0
[ 1553.882201]  ? _raw_spin_lock_irq+0x8e/0xe0
[ 1553.882206]  worker_thread+0x544/0x1180
[ 1553.882209]  ? __cpuidle_text_end+0x4/0x4
[ 1553.882214]  kthread+0x282/0x320
[ 1553.882218]  ? process_one_work+0x11c0/0x11c0
[ 1553.882221]  ? kthread_complete_and_exit+0x30/0x30
[ 1553.882225]  ret_from_fork+0x1f/0x30
[ 1553.882231]  </TASK>

There is no need to check error request validation in server.
This check allow invalid requests not to validate message.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17818
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - add missing fixes and stable tags.

 fs/ksmbd/smb2misc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index aa1e663d9deb..6e25ace36568 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -90,11 +90,6 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 	*off = 0;
 	*len = 0;
 
-	/* error reqeusts do not have data area */
-	if (hdr->Status && hdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
-	    (((struct smb2_err_rsp *)hdr)->StructureSize) == SMB2_ERROR_STRUCTURE_SIZE2_LE)
-		return ret;
-
 	/*
 	 * Following commands have data areas so we have to get the location
 	 * of the data buffer offset and data buffer length for the particular
-- 
2.25.1

