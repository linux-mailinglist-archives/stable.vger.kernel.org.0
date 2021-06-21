Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E593AF3C9
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 20:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhFUSFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233832AbhFUSCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 14:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22425613FE;
        Mon, 21 Jun 2021 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298111;
        bh=x/cTnFU7FnW/u2FVYFVcEmyJ6UDVKNwCF9ortI7Ugek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9oSl+DbR4/6jZfEzOgF12Ezjt6UiXRWZlM4AuVvmiMVSc4ymaXXd4JpUnVuzyt65
         JI1P2KlTxzfks6U6VeOukL5fgSSNxOSFNbVHQOkCpKiUgs92GbOrRUcfyYr00M5jku
         5i+rT1Bwb5SbkgujhDLQtxcBF8KG2Y6lfSlyovPyE+dRPY1xjpsWKmZgrRR0RBD6Ra
         0sCJ/KmtPFx/8V4T+NyJoBs5i0QCpeRfmlzu3RivHKQJos9spg1uw2qfvhgvF/7W3Q
         N3NLXKY+EfxHblgeMnYhIKV1vFTIwG8cMQjHGnKr1hIgx3eMCOuaOCbxOVDLnfS5y7
         2y/Nxa899SgdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/16] KVM: selftests: Fix kvm_check_cap() assertion
Date:   Mon, 21 Jun 2021 13:54:47 -0400
Message-Id: <20210621175450.736067-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175450.736067-1-sashal@kernel.org>
References: <20210621175450.736067-1-sashal@kernel.org>
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
index fb5d2d1e0c04..b138fd5e4620 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -55,7 +55,7 @@ int kvm_check_cap(long cap)
 		exit(KSFT_SKIP);
 
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
-	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
+	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
 
 	close(kvm_fd);
-- 
2.30.2

