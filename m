Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393B345A837
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbhKWQkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238389AbhKWQkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4043560FA0;
        Tue, 23 Nov 2021 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685415;
        bh=fJJDZ2OhFIQU4da2SyiIsTuTgELfj6WEyRyJXMVkv1U=;
        h=From:To:Cc:Subject:Date:From;
        b=lZlP1wtq779fzB4XF7DKkV+Qj6HAH7oq7jhfiWXRvr07/0Fcl8ke4pe4bVzLVnQuo
         u6gGAi7Hd14sxp78Km/F/yQtW183I4Qt8W/vp7kkUfIksgr1rjTzRyu5wPa+nc7mSF
         7MariqzMg+d+bLG+p7x+iTIRr+Ie604gFAziBiPfSEAH0KmPEjVq0hta81ikXvDAQx
         WdOkJck8S4EqBk+UTFdlDmhd0iyFoVbzqjcJgU3Kq8Jiq+pZNHH9F7X7UhjQ8n0hYU
         8P1dfC0LWA3aMnJwDhw5M+wDqr8dDsBFGLAcZkyp/DK7+G9u1q2OeMNXDzfAeEANZd
         y5KiR//3mjaYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 1/5] KVM: selftests: Fix kvm_vm_free() in cr4_cpuid_sync and vmx_tsc_adjust tests
Date:   Tue, 23 Nov 2021 11:36:45 -0500
Message-Id: <20211123163652.289483-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 22d7108ce47290d47e1ea83a28fbfc85e0ecf97e ]

The kvm_vm_free() statement here is currently dead code, since the loop
in front of it can only be left with the "goto done" that jumps right
after the kvm_vm_free(). Fix it by swapping the locations of the "done"
label and the kvm_vm_free().

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20210826074928.240942-1-thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 3 +--
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 140e91901582b..4d259294804fc 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -110,8 +110,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	kvm_vm_free(vm);
-
 done:
+	kvm_vm_free(vm);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index fbe8417cbc2c3..8b9fa313adf21 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -162,7 +162,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	kvm_vm_free(vm);
 done:
+	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.33.0

