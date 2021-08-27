Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B3F3F9CCC
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 18:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhH0Qun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 12:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233882AbhH0Qun (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 12:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630082994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhkHch2a2Nq/MBCYyoOXfRTqLt9ghm/Gbw3AzjsmZeo=;
        b=X977RlkvqRe1/g8OPOKPXTZAWg5k3U+KiJ1Hb563G5AoKiQMTb6+urGv/aS8EVQfWRMYaP
        5JH/hzIGCIbkx9LSBRqRw/3NlL0JNpoHh76NQi0y+rUZd45spZDv3ELg7G8C2VqeF3dx3g
        YsL0PNqsAhfRgm6Q5QLGVpfQmJ7Y8bw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-XxWSGH8tPiqOPk8jiMg5QQ-1; Fri, 27 Aug 2021 12:49:50 -0400
X-MC-Unique: XxWSGH8tPiqOPk8jiMg5QQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14857190A7A6;
        Fri, 27 Aug 2021 16:49:49 +0000 (UTC)
Received: from max.com (unknown [10.40.194.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74B3B60C04;
        Fri, 27 Aug 2021 16:49:42 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        kvm-ppc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v7 02/19] powerpc/kvm: Fix kvm_use_magic_page
Date:   Fri, 27 Aug 2021 18:49:09 +0200
Message-Id: <20210827164926.1726765-3-agruenba@redhat.com>
In-Reply-To: <20210827164926.1726765-1-agruenba@redhat.com>
References: <20210827164926.1726765-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When switching from __get_user to fault_in_pages_readable, commit
9f9eae5ce717 broke kvm_use_magic_page: fault_in_pages_readable returns 0
on success.  Fix that.

Fixes: 9f9eae5ce717 ("powerpc/kvm: Prefer fault_in_pages_readable function")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 arch/powerpc/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index 617eba82531c..d89cf802d9aa 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -669,7 +669,7 @@ static void __init kvm_use_magic_page(void)
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}
-- 
2.26.3

