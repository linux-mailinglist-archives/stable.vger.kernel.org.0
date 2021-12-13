Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40569472ED3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhLMOUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbhLMOU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E65C061748;
        Mon, 13 Dec 2021 06:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F660B8106C;
        Mon, 13 Dec 2021 14:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F3CC34601;
        Mon, 13 Dec 2021 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405225;
        bh=IgLSsDXku+1K9pPQ4iBiwNQcjZ7/ZAaYJa2R7oEqRzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCiphQO6FYNXmIlqL6TwgbGgQz5MXFJzXHbseETkb/ZXsJWyuYfo6rJPpgscmDVoo
         N7QokX9/kMkGs5oayoJw12UD2ABVNP/seYv5WU2sbwJlyUrEWiOl9bLfcNb07uYHqd
         bQ3WmVVC1HquyD1nJGhb4qXVI0hBv/fu6cnt6DrsuZETPKJ9bBTqAx56Gi/acw5g+G
         bQRFh5GNZqYqcUdqHawp4/+6x8brhGqmgD36MaWsNdrcHBeI0qtn5F7n0GMmsqJ+N/
         qKlGAmmSsh6Sd4pLJrwg9jdTvRWEaYPHtSB97UEO+9OgI5RwLNpAPHIii2+m+FqHcL
         3hHz/RI5hf/Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 3/4] KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
Date:   Mon, 13 Dec 2021 09:20:17 -0500
Message-Id: <20211213142020.352376-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213142020.352376-1-sashal@kernel.org>
References: <20211213142020.352376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 908fa88e420f30dde6d80f092795a18ec72ca6d3 ]

With the elevated 'KVM_CAP_MAX_VCPUS' value kvm_create_max_vcpus test
may hit RLIMIT_NOFILE limits:

 # ./kvm_create_max_vcpus
 KVM_CAP_MAX_VCPU_ID: 4096
 KVM_CAP_MAX_VCPUS: 1024
 Testing creating 1024 vCPUs, with IDs 0...1023.
 /dev/kvm not available (errno: 24), skipping test

Adjust RLIMIT_NOFILE limits to make sure KVM_CAP_MAX_VCPUS fds can be
opened. Note, raising hard limit ('rlim_max') requires CAP_SYS_RESOURCE
capability which is generally not needed to run kvm selftests (but without
raising the limit the test is doomed to fail anyway).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211123135953.667434-1-vkuznets@redhat.com>
[Skip the test if the hard limit can be raised. - Paolo]
Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/kvm/kvm_create_max_vcpus.c      | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 0299cd81b8ba2..aa3795cd7bd3d 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/resource.h>
 
 #include "test_util.h"
 
@@ -40,10 +41,39 @@ int main(int argc, char *argv[])
 {
 	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
 	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	/*
+	 * Number of file descriptors reqired, KVM_CAP_MAX_VCPUS for vCPU fds +
+	 * an arbitrary number for everything else.
+	 */
+	int nr_fds_wanted = kvm_max_vcpus + 100;
+	struct rlimit rl;
 
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
 
+	/*
+	 * Check that we're allowed to open nr_fds_wanted file descriptors and
+	 * try raising the limits if needed.
+	 */
+	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl), "getrlimit() failed!");
+
+	if (rl.rlim_cur < nr_fds_wanted) {
+		rl.rlim_cur = nr_fds_wanted;
+		if (rl.rlim_max < nr_fds_wanted) {
+			int old_rlim_max = rl.rlim_max;
+			rl.rlim_max = nr_fds_wanted;
+
+			int r = setrlimit(RLIMIT_NOFILE, &rl);
+			if (r < 0) {
+				printf("RLIMIT_NOFILE hard limit is too low (%d, wanted %d)\n",
+				       old_rlim_max, nr_fds_wanted);
+				exit(KSFT_SKIP);
+			}
+		} else {
+			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
+		}
+	}
+
 	/*
 	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
 	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
-- 
2.33.0

