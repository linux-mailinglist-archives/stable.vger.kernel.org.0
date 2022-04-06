Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331C64F6A41
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiDFTr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiDFTqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C5DF16B171
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 10:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649266470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJDGzsLQ8aHqakbYO9wo6BWOLXiPCK04bQY4XqKAUvE=;
        b=JDaKewMNv0O9t7Zf9XZR1FgQcrJ684XXbxi/OVxPNjlJZcysn/UvM7yMCLEFEkfRhQn3jF
        LK5WgKtoDFfbHFGp8XOeJrKSybTrpulS/tSq8uk9Ybw8ZhEuDTUnMtdt0D3p7bY7th6twa
        NCfJLhKVbXIFKmZ9iocS1rYpg2bdo9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-C-mgl1oyMPqN9DOej0lZjg-1; Wed, 06 Apr 2022 13:34:29 -0400
X-MC-Unique: C-mgl1oyMPqN9DOej0lZjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A291B100BAAF
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 17:34:18 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CDED4047295;
        Wed,  6 Apr 2022 17:34:18 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 2/2] fs: dlm: fix pending remove if msg allocation fails
Date:   Wed,  6 Apr 2022 13:34:16 -0400
Message-Id: <20220406173416.3882304-2-aahringo@redhat.com>
In-Reply-To: <20220406173416.3882304-1-aahringo@redhat.com>
References: <20220406173416.3882304-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch unsets ls_remove_len and ls_remove_name if a message
allocation of a remove messages fails. In this case we never send a
remove message out but set the per ls ls_remove_len ls_remove_name
variable for a pending remove. Unset those variable should indicate
possible waiters in wait_pending_remove() that no pending remove is
going on at this moment.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 137cf09b51e5..f5330e58d1fc 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4100,13 +4100,14 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
 	if (rv)
-		return;
+		goto out;
 
 	memcpy(ms->m_extra, name, len);
 	ms->m_hash = cpu_to_le32(hash);
 
 	send_message(mh, ms);
 
+out:
 	spin_lock(&ls->ls_remove_spin);
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
-- 
2.31.1

