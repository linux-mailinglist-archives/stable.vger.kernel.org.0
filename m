Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AC7584055
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiG1NuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiG1NuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:50:08 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4572362A4C;
        Thu, 28 Jul 2022 06:50:05 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id p8so1829826plq.13;
        Thu, 28 Jul 2022 06:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SL/nc3prOfupn2LlYJAxiJmSvJuuaV2EvEDV9LdRlv8=;
        b=EyO0i2rJlkDcp5LlCksbZ82NhZEvnfcrVu5YRYW/D5HIzQLcvHuCzkIXlVuuZnyvI4
         TTuTS4zNpHP4t/FPxjiRFPyGHNsfPTHY+z1LTwzPisI+wUA6ZN3yEDf6PKULEb/USbb+
         kYLqCPBG1L0gO8CRW7tQc20wTnr8FxhD8GagHtFIs5SuQvEBAxwI8Y0xj5rgHJntHr2N
         36aMBGXj5tJtyzRvdHjB9b36VV4LmQSzKu+Fxmyt4MYu6xTGFFUZ/vPdGIP94OTOcNkD
         Z8q0fIIYsWw2mYSZmJSvFe0O6wNb6CD5nTJID0Hh2sXAyv9xu0DgWoZDB6/DG/pZrN5b
         fbPQ==
X-Gm-Message-State: AJIora+9VcbfoxqiU5lyZ0GqCXibv+3HWsaAE0Lofxl6GnuWlgrpdGxq
        xzMrcX+ofIsIjhFTBd4UCQXY2weBuQI=
X-Google-Smtp-Source: AGRyM1vByUyJ+pDdwKe4yZ9tNgPpiCJO3P1mBTmhVX9IgtxqHGLI9FgWdDN/ZkamwMxvzo6oTnkphQ==
X-Received: by 2002:a17:90b:3148:b0:1f2:4651:255c with SMTP id ip8-20020a17090b314800b001f24651255cmr10279436pjb.18.1659016204129;
        Thu, 28 Jul 2022 06:50:04 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902eb8800b0016cf985c0fcsm491712plg.124.2022.07.28.06.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:50:03 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        stable@vger.kernel.org, zdi-disclosures@trendmicro.com
Subject: [PATCH v2 2/5] ksmbd: fix use-after-free bug in smb2_tree_disconect
Date:   Thu, 28 Jul 2022 22:49:43 +0900
Message-Id: <20220728134946.7603-2-linkinjeon@kernel.org>
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

smb2_tree_disconnect() freed the struct ksmbd_tree_connect,
but it left the dangling pointer. It can be accessed
again under compound requests.

This bug can lead an oops looking something link:

[ 1685.468014 ] BUG: KASAN: use-after-free in ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468068 ] Read of size 4 at addr ffff888102172180 by task kworker/1:2/4807
...
[ 1685.468130 ] Call Trace:
[ 1685.468132 ]  <TASK>
[ 1685.468135 ]  dump_stack_lvl+0x49/0x5f
[ 1685.468141 ]  print_report.cold+0x5e/0x5cf
[ 1685.468145 ]  ? ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468157 ]  kasan_report+0xaa/0x120
[ 1685.468194 ]  ? ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468206 ]  __asan_report_load4_noabort+0x14/0x20
[ 1685.468210 ]  ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468222 ]  smb2_tree_disconnect+0x175/0x250 [ksmbd]
[ 1685.468235 ]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[ 1685.468247 ]  process_one_work+0x778/0x11c0
[ 1685.468251 ]  ? _raw_spin_lock_irq+0x8e/0xe0
[ 1685.468289 ]  worker_thread+0x544/0x1180
[ 1685.468293 ]  ? __cpuidle_text_end+0x4/0x4
[ 1685.468297 ]  kthread+0x282/0x320
[ 1685.468301 ]  ? process_one_work+0x11c0/0x11c0
[ 1685.468305 ]  ? kthread_complete_and_exit+0x30/0x30
[ 1685.468309 ]  ret_from_fork+0x1f/0x30

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17816
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 v2:
   - add missing fixes and stable tags.

 fs/ksmbd/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 41ef076af072..7ecb6d87ae3e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2057,6 +2057,7 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
 	ksmbd_close_tree_conn_fds(work);
 	ksmbd_tree_conn_disconnect(sess, tcon);
+	work->tcon = NULL;
 	return 0;
 }
 
-- 
2.25.1

