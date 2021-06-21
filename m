Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53F3AF2C2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhFUR4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232314AbhFURzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB226135F;
        Mon, 21 Jun 2021 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297967;
        bh=j7cyp7H6Pq15LCDwLtRaQL0/mItbUSCDUqwruUQOUhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/dh8OA+mo964rqrJRJq3vOq6djrCgY4erc58L3J4BLUoHHBJaNyA9urqRMghdzXt
         1cybuWASb72074JQX+LRB5YCFsFPlWYX6asGfxa9sIwpavuaeu75CXaV8A5nDiGqCh
         n6/416GHtpVpNoIPj/SWXEJadsClsM9CjZpJBLl1UenvmACHlyTl44xI5YEfcWI3CN
         D26/hxX6jESgt2EfYO27Cvdxznt7q3xiTlqjtV74oSlcUqQ2q+ntJntEzjih74HmRM
         a4JgJdYaMRKXYZqCfLSv154fFrZnTrKWAvZd/nKEW5h547S9fssCL95mRngunW13j6
         h5ZwUIQknxzpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 31/39] KVM: selftests: Fix kvm_check_cap() assertion
Date:   Mon, 21 Jun 2021 13:51:47 -0400
Message-Id: <20210621175156.735062-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
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

