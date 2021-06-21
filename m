Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0F33AF392
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 20:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhFUSCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233599AbhFUSAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18235613E2;
        Mon, 21 Jun 2021 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298077;
        bh=6iiuKRkQlu1TIpuawsmuLZUAgfxWm/ksDT6yIMSfJ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXWzKeqijkw5psYBNA7WC7w8XpNdWbuA+/x19kgIwQhtl8pUXUHZ1BfKXQ+FoiEJ2
         MM++DO6T1cCk1eXNiuWHsH1fSqmVmWbIIiUgmfphfwj7bMfJuTfLfULRuo7xjMwLPv
         xOyNuJzBXxY0+TlntaSajZSOqvoKuycuaZSs13+130yfypHvcoRZUESa7Uwk61oJ4J
         lpmD6Wy0q35hV+uvz6PPVTZV8qbBBjVNdwi0HPbooUkAAmgASboBUYUU3UQsgnql10
         MN1KLeTz7sc16vqlHLqv+vZQ5YJLrlsa2W10nYZ7Kv5j1ADVdDHccyzRoADsAoNkvM
         IUbAxWo7HhIRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/26] KVM: selftests: Fix kvm_check_cap() assertion
Date:   Mon, 21 Jun 2021 13:53:54 -0400
Message-Id: <20210621175400.735800-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
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
index 41cf45416060..38de88e5ffbb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -54,7 +54,7 @@ int kvm_check_cap(long cap)
 		exit(KSFT_SKIP);
 
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
-	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
+	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
 
 	close(kvm_fd);
-- 
2.30.2

