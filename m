Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40282017F1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbgFSQpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387988AbgFSOmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:42:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 971B220CC7;
        Fri, 19 Jun 2020 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577726;
        bh=lbF6sIeU9WMTXx2rz1p0SggkawNhrB2OOVw0p1MoR6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwCkymbbME3nb5i0MQagV16H0UlTDe8IpM3S7qnYK6FqqxhoWqShjC9NX8kJUJCIK
         5cLzCdN9NKuTQzSAAPjVe0mlgpgCcFDQxlsLesA5u1FMiDJmgYBNRT+ig3rir2yfS3
         VcQ71/XqhtDilJTl7CWUzUk7Or2M4h9Bqx4aD8DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jon Doron <arilou@gmail.com>,
        Roman Kagan <rvkagan@yandex-team.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/128] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Fri, 19 Jun 2020 16:32:39 +0200
Message-Id: <20200619141623.648443544@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



