Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECA5423F52
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbhJFNcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238668AbhJFNcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A41761075;
        Wed,  6 Oct 2021 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527023;
        bh=9qZBQ9nSSGmzYKY0SK0EQqGdDNghIYVVge/l33TN3ZY=;
        h=From:To:Cc:Subject:Date:From;
        b=Tkb3pEoHGlfHwUB66TL16IMFMczqvRR8bMGnFQsqlW1v4YEebjXQI8HNB/SM2zRQE
         BVrmhhKb/d6+YGHancRCxaoXl6s2QNRdZbh0Trdw/SlT80Oc5al9Ryygx1fAGfvqVU
         dXzq0ATIdIgs0p1B61nVqnHKZiJKK8somkJ7E9otJMHPYXtI7bqcJ09fBdyBZZGdbH
         eML0aRgoRdtn3w7OJLWSTs2aDCANJOWKXLDaEXCwmiQ0boHs0yb+fOHzhhNtU3O60/
         7M2Fl1DlXsqgXbxlOZAX2CfhwCfp1A/xUqX2v7BuI/o2NHS39Fc2EYq41YPsJiX3Yj
         B8nqwXFDFZZww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 1/9] selftests: KVM: Align SMCCC call with the spec in steal_time
Date:   Wed,  6 Oct 2021 09:30:13 -0400
Message-Id: <20211006133021.271905-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit 01f91acb55be7aac3950b89c458bcea9ef6e4f49 ]

The SMC64 calling convention passes a function identifier in w0 and its
parameters in x1-x17. Given this, there are two deviations in the
SMC64 call performed by the steal_time test: the function identifier is
assigned to a 64 bit register and the parameter is only 32 bits wide.

Align the call with the SMCCC by using a 32 bit register to handle the
function identifier and increasing the parameter width to 64 bits.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Message-Id: <20210921171121.2148982-3-oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/steal_time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..aafaa8e38b7c 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,12 +118,12 @@ struct st_time {
 	uint64_t st_time;
 };
 
-static int64_t smccc(uint32_t func, uint32_t arg)
+static int64_t smccc(uint32_t func, uint64_t arg)
 {
 	unsigned long ret;
 
 	asm volatile(
-		"mov	x0, %1\n"
+		"mov	w0, %w1\n"
 		"mov	x1, %2\n"
 		"hvc	#0\n"
 		"mov	%0, x0\n"
-- 
2.33.0

