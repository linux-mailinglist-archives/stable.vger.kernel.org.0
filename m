Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991843B616C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhF1Of5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhF1Ocs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE21061C7C;
        Mon, 28 Jun 2021 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890467;
        bh=tkmf6/6OeAXh1cg0sElhxYdTTvOAK7Oe8FM4NgV8fu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOMvesBRrVhLoeED2XcnilWZCjlyJuR8Gla6vczLS13wxo8rXzOepZybpBb1oH0LY
         NUTlGtJtlf2cGIlwlZxbhrX9MSDMxJYzNOVBU3SYaHJRXLoM3pSt5zCHpD+sw/uKHS
         tmB4oDh7TSjNvEvmrgNZLmc2JJX7Q1Zh6Fh+6szKpmscIwl4TtpF5Tu5oGrF9BkeEu
         VlfL6OAhceZlKkmUSY9DlYqu/MD4+OmLNZNJxZcn6fNgeNd2QunZ7+ukyZKtrPAkNS
         DrFcTcIH/F7DMs8rU7HqCbLxjkd7agvCPE2wLbVeA1RNQoIbaXxH8u8cvLDWy07ff1
         u+rxxQ7aqTVMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alper Gun <alpergun@google.com>, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 093/101] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
Date:   Mon, 28 Jun 2021 10:25:59 -0400
Message-Id: <20210628142607.32218-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alper Gun <alpergun@google.com>

commit 934002cd660b035b926438244b4294e647507e13 upstream.

Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
fails. If a failure happens after  a successful LAUNCH_START command,
a decommission command should be executed. Otherwise, guest context
will be unfreed inside the AMD SP. After the firmware will not have
memory to allocate more SEV guest context, LAUNCH_START command will
begin to fail with SEV_RET_RESOURCE_LIMIT error.

The existing code calls decommission inside sev_unbind_asid, but it is
not called if a failure happens before guest activation succeeds. If
sev_bind_asid fails, decommission is never called. PSP firmware has a
limit for the number of guests. If sev_asid_binding fails many times,
PSP firmware will not have resources to create another guest context.

Cc: stable@vger.kernel.org
Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
Reported-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Alper Gun <alpergun@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210610174604.2554090-1-alpergun@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 16b10b9436dc..01547bdbfb06 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -130,9 +130,25 @@ static void sev_asid_free(int asid)
 	mutex_unlock(&sev_bitmap_lock);
 }
 
-static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission *decommission;
+
+	if (!handle)
+		return;
+
+	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
+	if (!decommission)
+		return;
+
+	decommission->handle = handle;
+	sev_guest_decommission(decommission, NULL);
+
+	kfree(decommission);
+}
+
+static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+{
 	struct sev_data_deactivate *data;
 
 	if (!handle)
@@ -152,15 +168,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
 	kfree(data);
 
-	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
-	if (!decommission)
-		return;
-
-	/* decommission handle */
-	decommission->handle = handle;
-	sev_guest_decommission(decommission, NULL);
-
-	kfree(decommission);
+	sev_decommission(handle);
 }
 
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -288,8 +296,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start->handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start->handle);
 		goto e_free_session;
+	}
 
 	/* return handle to userspace */
 	params.handle = start->handle;
-- 
2.30.2

