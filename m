Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236383AF333
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhFUSAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232119AbhFUR6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2224E613C3;
        Mon, 21 Jun 2021 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298023;
        bh=R0eM+JPuOKwgSKHHLCwyDIqz+/QuEff9VtRTavBuU+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3QoVgE0RUDRvoIgX47Er+4lqxLW7kRbr89y083JX2O6JGUS7g33IL/LyWnIoyTaV
         lI9ka0UrDqYqYHhx0bag8akFZtJHuubmV9kWXy+SB17y4wtqyiBHkak5SuvvMrNtfC
         nr3bsh+LvUSS/iNKx76rPubFU52OHCbbscqR2OJ2AJiiFs+wntdSeUPk+cqvL588AH
         q/I08pDal8ThU8MyLdbB28WEvxobVN8s8A4fEWbTexq9rlvaxTc5++ZnmaIyw9Jxkr
         irbivBSo7x4Xp+nl1VD8otXH222V4nOMsoI6lPLv+3vOsHLThm38i7sUofqhnfRP/Z
         RsYLECNe0FRcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/35] KVM: selftests: Fix kvm_check_cap() assertion
Date:   Mon, 21 Jun 2021 13:52:53 -0400
Message-Id: <20210621175300.735437-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index 126c6727a6b0..49805fd16fdf 100644
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

