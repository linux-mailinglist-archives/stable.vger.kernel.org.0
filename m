Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A317745A823
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhKWQjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235635AbhKWQjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:39:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D38B60F5B;
        Tue, 23 Nov 2021 16:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685401;
        bh=t4/zS9EALiqTaAb4F8IW40rN8Jv7H6eywALNBHC7/6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBuTLo+EatmicXAx6awZLzALtBBi/q7d3pGaRtdL5qfleYV/ag/7lZJLNHtViAQos
         4RVyxwGibvToE6wkDCpLyvj/iFEOn+j7bClhqErlHH1QwrK7Yi0pqqkWUHULCSueUu
         6MaYg68xXsJMMuKExyyNvUFXUgi1FJAmXoLC5HbUhqHFquqVHN1nSwdJzXmBjMhlDe
         C34i4Xg1LZXlOSnzm+HSIUtgsMcrwQDYKCs8xyCWP/FAUnvpXTC4GYF7eo7EA/5ib/
         N8gzGzf/yFTW3jKaZXjmJxbl5x0eT2auSvoxItuYCJ2ppY79F7ORz1RFeQehGvEIqi
         w5yIHX8JEyJOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 4/8] KVM: selftests: Fix kvm_vm_free() in cr4_cpuid_sync and vmx_tsc_adjust tests
Date:   Tue, 23 Nov 2021 11:36:26 -0500
Message-Id: <20211123163630.289306-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163630.289306-1-sashal@kernel.org>
References: <20211123163630.289306-1-sashal@kernel.org>
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
index f40fd097cb359..6f6fd189dda3f 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -109,8 +109,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	kvm_vm_free(vm);
-
 done:
+	kvm_vm_free(vm);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 7e33a350b053a..e683d0ac3e45e 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -161,7 +161,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	kvm_vm_free(vm);
 done:
+	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.33.0

