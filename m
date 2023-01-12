Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B37D6686C2
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjALWUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbjALWUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:20:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D3D13DCA
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673561461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZEbNok/Vyp/lU6KvmbvDzHE9/fsYHz8NrD8ajexzCM=;
        b=eJzrBd0/dr6oZ3VOTjmi/2Zutyb6ULm6hjhwpTny802EUX40qoBRZjNqvD3Ple4Hr1Fv1F
        HmY25PPH7CO96LRhtDsXXJg2xt1hkqe86dqzLSEE1kSHBE0hHVbBk49owHruE5c/upmH3S
        kWfudcjVm7aO+0KtTEgNu3AEax59ZZQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-IJlBxjhVPp-6Lzoqw-G5vA-1; Thu, 12 Jan 2023 17:10:57 -0500
X-MC-Unique: IJlBxjhVPp-6Lzoqw-G5vA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC93E802D1B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 22:10:56 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5F401121314;
        Thu, 12 Jan 2023 22:10:56 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, aahringo@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH dlm/next 3/7] fs: dlm: be sure to call dlm_send_queue_flush()
Date:   Thu, 12 Jan 2023 17:10:33 -0500
Message-Id: <20230112221037.1882548-3-aahringo@redhat.com>
In-Reply-To: <20230112221037.1882548-1-aahringo@redhat.com>
References: <20230112221037.1882548-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we release a midcomms node structure there should be nothing left
inside the dlm midcomms send queue. However sometimes we have this case
because I believe some DLM_FIN message didn't got acked... if we run
into a timeout handling then we should be sure there is no pending send
dlm message inside this queue when releasing midcomms node structure.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/midcomms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 2e60d9a2c883..a3eb19c8cec5 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1402,6 +1402,7 @@ static void midcomms_node_release(struct rcu_head *rcu)
 	struct midcomms_node *node = container_of(rcu, struct midcomms_node, rcu);
 
 	WARN_ON_ONCE(atomic_read(&node->send_queue_cnt));
+	dlm_send_queue_flush(node);
 	kfree(node);
 }
 
-- 
2.31.1

