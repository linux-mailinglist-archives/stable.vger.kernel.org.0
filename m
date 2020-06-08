Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B921F2D77
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgFIAds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgFHXOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598ED20C09;
        Mon,  8 Jun 2020 23:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658088;
        bh=vXYk7JUvoeakSGmPKmqeDoVsAFE/QUqU1NhtnvOHL0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObgWlcolMem3z4ya4QgbYf9Qx81nUplV6n4vlh+yGDLQna7yO0r9AkK0GJIB4sIYm
         KADzNxwf+24NasCvo+qvT8XmV9nWQ9T+cqGV9MBut09UZnlvpeKBL6WkCMKnNTvdu5
         SxzOOnGXDkY5lPIwNoGVrvglxBSgXhy13kVMQGnw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 131/606] KVM: selftests: Fix build for evmcs.h
Date:   Mon,  8 Jun 2020 19:04:16 -0400
Message-Id: <20200608231211.3363633-131-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 8ffdaf9155ebe517cdec5edbcca19ba6e7ee9c3c ]

I got this error when building kvm selftests:

/usr/bin/ld: /home/xz/git/linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:222: multiple definition of `current_evmcs'; /tmp/cco1G48P.o:/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:222: first defined here
/usr/bin/ld: /home/xz/git/linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:223: multiple definition of `current_vp_assist'; /tmp/cco1G48P.o:/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:223: first defined here

I think it's because evmcs.h is included both in a test file and a lib file so
the structs have multiple declarations when linking.  After all it's not a good
habit to declare structs in the header files.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20200504220607.99627-1-peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/evmcs.h  | 4 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/evmcs.h b/tools/testing/selftests/kvm/include/evmcs.h
index 4912d23844bc..e31ac9c5ead0 100644
--- a/tools/testing/selftests/kvm/include/evmcs.h
+++ b/tools/testing/selftests/kvm/include/evmcs.h
@@ -217,8 +217,8 @@ struct hv_enlightened_vmcs {
 #define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK	\
 		(~((1ull << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT) - 1))
 
-struct hv_enlightened_vmcs *current_evmcs;
-struct hv_vp_assist_page *current_vp_assist;
+extern struct hv_enlightened_vmcs *current_evmcs;
+extern struct hv_vp_assist_page *current_vp_assist;
 
 int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 7aaa99ca4dbc..ce528f3cf093 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -17,6 +17,9 @@
 
 bool enable_evmcs;
 
+struct hv_enlightened_vmcs *current_evmcs;
+struct hv_vp_assist_page *current_vp_assist;
+
 struct eptPageTableEntry {
 	uint64_t readable:1;
 	uint64_t writable:1;
-- 
2.25.1

