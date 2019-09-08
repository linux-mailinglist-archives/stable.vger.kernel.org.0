Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87DFACDEC
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfIHMsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731049AbfIHMsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:30 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A2E2190F;
        Sun,  8 Sep 2019 12:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946909;
        bh=rfkglOyvq4OR2/j3cMamc1ybAJE2wI+Z2fICSfOwW7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVXMiQqXKCYYhF+aSTtFhHrv/t5piANewYHSzWQ3Cfyc3WAaN1KIJx44zLxMj21Mm
         Q4XsU7QicW4o2CfDXE19yhCZo5Atk0x/ZSEoYBf+miNEJSeu7Ew2wyY83W11+ifYKz
         CeDXMXcYSr+o0DqIWEAY5AK+hpEY9dO8j46JHuO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/57] selftests: kvm: fix state save/load on processors without XSAVE
Date:   Sun,  8 Sep 2019 13:42:11 +0100
Message-Id: <20190908121145.705611058@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 54577e5018a8c0cb79c9a0fa118a55c68715d398 ]

state_test and smm_test are failing on older processors that do not
have xcr0.  This is because on those processor KVM does provide
support for KVM_GET/SET_XSAVE (to avoid having to rely on the older
KVM_GET/SET_FPU) but not for KVM_GET/SET_XCRS.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/x86.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86.c b/tools/testing/selftests/kvm/lib/x86.c
index a3122f1949a8e..4d35eba73dc97 100644
--- a/tools/testing/selftests/kvm/lib/x86.c
+++ b/tools/testing/selftests/kvm/lib/x86.c
@@ -809,9 +809,11 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
         TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
                 r);
 
-	r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XCRS, r: %i",
-                r);
+	if (kvm_check_cap(KVM_CAP_XCRS)) {
+		r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
+		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XCRS, r: %i",
+			    r);
+	}
 
 	r = ioctl(vcpu->fd, KVM_GET_SREGS, &state->sregs);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_SREGS, r: %i",
@@ -858,9 +860,11 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
         TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
                 r);
 
-	r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
-                r);
+	if (kvm_check_cap(KVM_CAP_XCRS)) {
+		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
+		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
+			    r);
+	}
 
 	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-- 
2.20.1



