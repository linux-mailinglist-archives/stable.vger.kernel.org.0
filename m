Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6341F2742
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbgFHXoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732086AbgFHX06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:26:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0B72072F;
        Mon,  8 Jun 2020 23:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658817;
        bh=lbF6sIeU9WMTXx2rz1p0SggkawNhrB2OOVw0p1MoR6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIGAiarW4kfveIv8GEt2irnVjKU3TJqkbtFGxQLM+9+JM9zz41rUGhTMf0a+yKFIQ
         rG1bPsHM+PdWbzu4YubhPWu3a/ZRXQfbQVEmHZAW71jijsX+TKa5HiiLZ94lnDi7Hp
         7LWtZ11nZKJYWX4BbvgtAJNZBCpf1Ru9vKyvJZvs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Doron <arilou@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rvkagan@yandex-team.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/50] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Mon,  8 Jun 2020 19:26:03 -0400
Message-Id: <20200608232640.3370262-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232640.3370262-1-sashal@kernel.org>
References: <20200608232640.3370262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Doron <arilou@gmail.com>

[ Upstream commit f7d31e65368aeef973fab788aa22c4f1d5a6af66 ]

The problem the patch is trying to address is the fact that 'struct
kvm_hyperv_exit' has different layout on when compiling in 32 and 64 bit
modes.

In 64-bit mode the default alignment boundary is 64 bits thus
forcing extra gaps after 'type' and 'msr' but in 32-bit mode the
boundary is at 32 bits thus no extra gaps.

This is an issue as even when the kernel is 64 bit, the userspace using
the interface can be both 32 and 64 bit but the same 32 bit userspace has
to work with 32 bit kernel.

The issue is fixed by forcing the 64 bit layout, this leads to ABI
change for 32 bit builds and while we are obviously breaking '32 bit
userspace with 32 bit kernel' case, we're fixing the '32 bit userspace
with 64 bit kernel' one.

As the interface has no (known) users and 32 bit KVM is rather baroque
nowadays, this seems like a reasonable decision.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
Message-Id: <20200424113746.3473563-2-arilou@gmail.com>
Reviewed-by: Roman Kagan <rvkagan@yandex-team.ru>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virtual/kvm/api.txt | 2 ++
 include/uapi/linux/kvm.h          | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index d1908e50b506..b8f5bf2a890a 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3534,9 +3534,11 @@ EOI was received.
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 			__u32 type;
+			__u32 pad1;
 			union {
 				struct {
 					__u32 msr;
+					__u32 pad2;
 					__u64 control;
 					__u64 evt_page;
 					__u64 msg_page;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a0a365cbf3c9..0c02441d2cc9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -159,9 +159,11 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
-- 
2.25.1

