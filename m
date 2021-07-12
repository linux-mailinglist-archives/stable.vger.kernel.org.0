Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1193C532A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347774AbhGLHxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243093AbhGLHrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D1796144C;
        Mon, 12 Jul 2021 07:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075754;
        bh=QEU95OBl1wa7Ix8cCNHen/j2cLQYlv1H8ToXGIkwAFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4ToszOVaVjDCMAS0NcNOQ2yBi38LzF0Skoz8PrBtJnj7C8IvBiBneGTcgByJeXJC
         tpJBTwAtJCItDCA8pWHWMUEfkogyxJC6beIVSOh/dxjwfAyuK3ZlJ8Bdq8N08Dfx5u
         ahitutrMXmAXPvqMT7PoKXN0BzPk7L4yqGt3JsBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 351/800] KVM: selftests: Remove errant asm/barrier.h include to fix arm64 build
Date:   Mon, 12 Jul 2021 08:06:14 +0200
Message-Id: <20210712061004.409286299@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ecc3a92c6f4953c134a9590c762755e6593f507c ]

Drop an unnecessary include of asm/barrier.h from dirty_log_test.c to
allow the test to build on arm64.  arm64, s390, and x86 all build cleanly
without the include (PPC and MIPS aren't supported in KVM's selftests).

arm64's barrier.h includes linux/kasan-checks.h, which is not copied
into tools/.

  In file included from ../../../../tools/include/asm/barrier.h:8,
                   from dirty_log_test.c:19:
     .../arm64/include/asm/barrier.h:12:10: fatal error: linux/kasan-checks.h: No such file or directory
     12 | #include <linux/kasan-checks.h>
        |          ^~~~~~~~~~~~~~~~~~~~~~
  compilation terminated.

Fixes: 84292e565951 ("KVM: selftests: Add dirty ring buffer test")
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622200529.3650424-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 81edbd23d371..b4d24f50aca6 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -16,7 +16,6 @@
 #include <errno.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
-#include <asm/barrier.h>
 #include <linux/atomic.h>
 
 #include "kvm_util.h"
-- 
2.30.2



