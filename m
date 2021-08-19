Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7363F20C6
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 21:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbhHSTmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 15:42:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234748AbhHSTmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 15:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629402084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhkHch2a2Nq/MBCYyoOXfRTqLt9ghm/Gbw3AzjsmZeo=;
        b=GIcJCTUNdOXeHsMw7IFnDTx73HkI96+fOKVaPnzNHvnzUCJ9qI2Z6dga7OWF6RQCh6UZFW
        qYxYVDg2/jmVuVV9v7BUzq2HeotnHjvvUcV+tcu71xVyvPLaufLSu0gTRdQ5RtLHX45THm
        6i9clWE34mVhns0hx6U0N93UylxV3EE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-DUy2fFkuM5ePm4thR6-QLw-1; Thu, 19 Aug 2021 15:41:20 -0400
X-MC-Unique: DUy2fFkuM5ePm4thR6-QLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC1C11026205;
        Thu, 19 Aug 2021 19:41:18 +0000 (UTC)
Received: from max.com (unknown [10.40.194.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 903221B46B;
        Thu, 19 Aug 2021 19:41:15 +0000 (UTC)
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
Subject: [PATCH v6 02/19] powerpc/kvm: Fix kvm_use_magic_page
Date:   Thu, 19 Aug 2021 21:40:45 +0200
Message-Id: <20210819194102.1491495-3-agruenba@redhat.com>
In-Reply-To: <20210819194102.1491495-1-agruenba@redhat.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

