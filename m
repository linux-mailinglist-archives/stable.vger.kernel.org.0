Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAABC47AEED
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbhLTPGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239413AbhLTPEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:04:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A1FC09B10F;
        Mon, 20 Dec 2021 06:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C490611CD;
        Mon, 20 Dec 2021 14:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAECC36AED;
        Mon, 20 Dec 2021 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011960;
        bh=IgLSsDXku+1K9pPQ4iBiwNQcjZ7/ZAaYJa2R7oEqRzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bD7kSTDuW/8NsJJ87YOIOuyM9xFASmPi5gkbxi1VyG39MJRh9eyQ98kndhckNj27F
         6a8pIn+5adkjOYwcoM4yBiTLLdRFb+5gUMgzKw0r969k5SVA+nDmpe7b7gKw+FHWPs
         /v9M/ITlVTQc+LiSsqBFQqi8CHh0dtEuXIMsxJSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/177] KVM: selftests: Make sure kvm_create_max_vcpus test wont hit RLIMIT_NOFILE
Date:   Mon, 20 Dec 2021 15:32:33 +0100
Message-Id: <20211220143040.171484374@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



