Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8A03B601C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhF1OWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233221AbhF1OVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A380361C7F;
        Mon, 28 Jun 2021 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889954;
        bh=j7cyp7H6Pq15LCDwLtRaQL0/mItbUSCDUqwruUQOUhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPzHivwGDQ6zxUipYtPs3Q6h1jz/bgIez6NV90+rTu7M/ZEauvy5tyvin18LosMqe
         eYg9LvpOw/LmKYMTKfw0DYVFwN38r7N/gRQQP5iw6Qd2YcnwCPX1hEtX5gizWBCHdg
         Ztjw+UAgnq6CHlLfvRxxS+KvayMJVZ5kF7c2NuX+8b8SeAnrYPiJTNV3kPd44WCZ38
         QhgQmbxvlO68ytv/JmrDwjS158rgSYkzSJLtJn5LkKwd/xxbuQNdGqI/G/jiZnwVgk
         6cXENA5ZxK6x0gLKzk0EjmwcGPXJ+iPa4C1VTouCczsAGGmY/LUPccjO9K6nzhEopb
         JKg2/RRKvjc1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 052/110] KVM: selftests: Fix kvm_check_cap() assertion
Date:   Mon, 28 Jun 2021 10:17:30 -0400
Message-Id: <20210628141828.31757-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

[ Upstream commit d8ac05ea13d789d5491a5920d70a05659015441d ]

KVM_CHECK_EXTENSION ioctl can return any negative value on error,
and not necessarily -1. Change the assertion to reflect that.

Signed-off-by: Fuad Tabba <tabba@google.com>
Message-Id: <20210615150443.1183365-1-tabba@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2f0e4365f61b..8b90256bca96 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -58,7 +58,7 @@ int kvm_check_cap(long cap)
 		exit(KSFT_SKIP);
 
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
-	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
+	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
 
 	close(kvm_fd);
-- 
2.30.2

