Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B991E57D648
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiGUVxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiGUVxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78A2993629
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 14:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658440432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zH9TDDMVkOcitYcBwao7CbPA3FTtgET3ZFMF76yyeRk=;
        b=Sp7zTf4KkC3GpdkrbzC4hiGnmwIhNg8QQGfGHP1KcjGVmrVXSCUZTd4cW7JRE3B/I+ljea
        gGA+oxnLVXFNz4HO4l8c2yfZ6sTa/pwxdwhFzrZIFStuR2Un0imK9QPpGMwTfELq4IIuQl
        ucDeNeZy4DFuMHYJd/A0lxHt7tXKKYU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-UHgG9Q20M3Oy4vhYDzoSwQ-1; Thu, 21 Jul 2022 17:53:51 -0400
X-MC-Unique: UHgG9Q20M3Oy4vhYDzoSwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C16D985A586
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 21:53:50 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E34A2026D64;
        Thu, 21 Jul 2022 21:53:50 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 2/3] fs: dlm: avoid double list_add() for lkb->lkb_cb_list
Date:   Thu, 21 Jul 2022 17:53:39 -0400
Message-Id: <20220721215340.936838-3-aahringo@redhat.com>
In-Reply-To: <20220721215340.936838-1-aahringo@redhat.com>
References: <20220721215340.936838-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dlm_add_cb() can run multiple times for a lkb to add a callback and
calling list_add() to calling queue_work() for later. If it's getting
called multiple times while test_bit(LSFL_CB_DELAY, &ls->ls_flags)
is true we need to ensure it was added only once or the list getting
corrupted. The list holder lkb->lkb_cb_list is being used with
list_del_init()/INIT_LIST_HEAD() and can be used with list_empty()
to check if it is not being part of a list.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index a44cc42b6317..0271796d36b1 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -202,7 +202,8 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 
 		mutex_lock(&ls->ls_cb_mutex);
 		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
-			list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
+			if (list_empty(&lkb->lkb_cb_list))
+				list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
 		} else {
 			queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
 		}
-- 
2.31.1

