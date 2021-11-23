Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3CD45A862
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhKWQlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239247AbhKWQk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A27060F6F;
        Tue, 23 Nov 2021 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685437;
        bh=fHpZ3rcMX2LjOJ2r/vANQx7fiGUw8T6W4YFAWK0L8Zw=;
        h=From:To:Cc:Subject:Date:From;
        b=kX9P419j5Fx85za0VbuA/4xZPX5F1GD32dUVWPK5Ha6DcgNTyTj0Slz7xcL1spT8p
         II0kjzF4mgmHJt+w7x0teCieF0mQNPQYwUvTUD1Zug2THA85LtvpT4GfWgwTg3YdW5
         4bDgt+PiAoYyHM/GVUjk4CpVVM5/3DTrnQnHssJQnQ0DDhg75T4O3w482QJ+SEPoB6
         iW4heQls+IdDhVxIBGpPfq/9ZNTB17YbdUZvKZrVWN4yVY2g6BHACNwmHJviAcvuSc
         cxI+umFmxjW16WqTCbUhUP0xif4LN1NsA9n7BMnVdguCmdpZZPA4JEbcTGFjPfnDkX
         Y7IMOoBnpNbzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 4.19 1/4] KVM: selftests: Fix kvm_vm_free() in cr4_cpuid_sync and vmx_tsc_adjust tests
Date:   Tue, 23 Nov 2021 11:37:12 -0500
Message-Id: <20211123163715.289631-1-sashal@kernel.org>
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
 tools/testing/selftests/kvm/cr4_cpuid_sync_test.c | 3 +--
 tools/testing/selftests/kvm/vmx_tsc_adjust_test.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
index 11ec358bf9690..8806ada996b60 100644
--- a/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
@@ -106,8 +106,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	kvm_vm_free(vm);
-
 done:
+	kvm_vm_free(vm);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
index 49bcc68b02350..bae7e9072382c 100644
--- a/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
@@ -169,7 +169,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	kvm_vm_free(vm);
 done:
+	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.33.0

