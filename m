Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA816833C6
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 18:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjAaRXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 12:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjAaRXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 12:23:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E6F5422F
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 09:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=O6xc7yUQ+r4mGl3gQ8IQAPstO5OTYvuNZtxO7PVTBMY=;
        b=O/vyTCCDdt8ZfXJWgZ+aaVSWvJlh38NT/K7P9AnRQO4eVaYq91sWykgZhZqLnBwp6HJ/Ud
        +dDIX200X1trbGdLTz4wU1ZWzB43STAM7SgYSo8BhuOqUjWFr8Z8lu9evgaAM8JzofYiwK
        Jco+nChg7oyu2rWQo1/ILbm2fNF2qpU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-pbV9lm5-NOmj2ZG9wDkk0Q-1; Tue, 31 Jan 2023 12:21:57 -0500
X-MC-Unique: pbV9lm5-NOmj2ZG9wDkk0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFF893814945;
        Tue, 31 Jan 2023 17:21:56 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 593D7112132C;
        Tue, 31 Jan 2023 17:21:56 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Seth Jenkins <sethjenkins@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org
Subject: [PATCH][v2] aio: fix mremap after fork null-deref
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 31 Jan 2023 12:25:55 -0500
Message-ID: <x49sffq4nvg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
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

From: Seth Jenkins <sethjenkins@google.com>

Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
a null-deref if mremap is called on an old aio mapping after fork as
mm->ioctx_table will be set to NULL.

Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
[JEM: fixed 80 column issue]
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
This passes the libaio test harness and fstests ./check -g aio.  I also
wrote a targeted test program and verified the issue was fixed.

 fs/aio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 562916d85cba..e85ba0b77f59 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -361,6 +361,9 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
+	if (!table)
+		goto out_unlock;
+
 	for (i = 0; i < table->nr; i++) {
 		struct kioctx *ctx;
 
@@ -374,6 +377,7 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 		}
 	}
 
+out_unlock:
 	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 	return res;

