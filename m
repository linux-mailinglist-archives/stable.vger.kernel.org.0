Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2731F2A27
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgFHXUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgFHXUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED1E920842;
        Mon,  8 Jun 2020 23:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658402;
        bh=7NsuvXTif01JnkdbHSo08MuqQTzSoDAw+D/hR9QqYyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18Ns0+m9zNFG1amRijtElzut4WA4/gs65HWZlH/EZshaeP4NDzfKATZyIX1hyt+BR
         u5S1BKJBwA8fV+qZJiJb2XR0kJJvQKkANvHX4eRch4sIpZINhu+FmGgAhdeVHSUyOS
         fiLz1yR+NaCnYUwX7emtxxTnhRcfPAADaoBoEiGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Doron <arilou@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rvkagan@yandex-team.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 057/175] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Mon,  8 Jun 2020 19:16:50 -0400
Message-Id: <20200608231848.3366970-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
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
 Documentation/virt/kvm/api.txt | 2 ++
 include/uapi/linux/kvm.h       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 4833904d32a5..a18e996fa54b 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4444,9 +4444,11 @@ EOI was received.
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
index 52641d8ca9e8..e735bc4075dc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -189,9 +189,11 @@ struct kvm_hyperv_exit {
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

