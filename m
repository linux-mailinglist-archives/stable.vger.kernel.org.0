Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7223A2E3F8F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502501AbgL1O1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502253AbgL1O1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD6122B45;
        Mon, 28 Dec 2020 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165630;
        bh=9Y+GB9T/BkLl75B8lh9AlbmTY11GfxqCcR4U2fuvGdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQi0Da7a2dccsXg6WlGwFyMBX934CTnogO5KFGP3Rt3eHb2jkJqEHjsW+Zx92ZFas
         m+1b+v5JNeEPeZ+dsWhTzuyY9zmGxCZUem1XpdHnmBs95/gUKIvJcL9odrxwN3XJ5O
         hNTipJFJ853cp0Xf88AWYnY1YHQu7YU4BGVoPGns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 599/717] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Mon, 28 Dec 2020 13:49:57 +0100
Message-Id: <20201228125049.605150382@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 9d4747d02376aeb8de38afa25430de79129c5799 upstream.

When both KVM support and the CCP driver are built into the kernel instead
of as modules, KVM initialization can happen before CCP initialization. As
a result, sev_platform_status() will return a failure when it is called
from sev_hardware_setup(), when this isn't really an error condition.

Since sev_platform_status() doesn't need to be called at this time anyway,
remove the invocation from sev_hardware_setup().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <618380488358b56af558f2682203786f09a49483.1607620209.git.thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm/sev.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1127,9 +1127,6 @@ void sev_vm_destroy(struct kvm *kvm)
 
 int __init sev_hardware_setup(void)
 {
-	struct sev_user_data_status *status;
-	int rc;
-
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
@@ -1148,26 +1145,9 @@ int __init sev_hardware_setup(void)
 	if (!sev_reclaim_asid_bitmap)
 		return 1;
 
-	status = kmalloc(sizeof(*status), GFP_KERNEL);
-	if (!status)
-		return 1;
-
-	/*
-	 * Check SEV platform status.
-	 *
-	 * PLATFORM_STATUS can be called in any state, if we failed to query
-	 * the PLATFORM status then either PSP firmware does not support SEV
-	 * feature or SEV firmware is dead.
-	 */
-	rc = sev_platform_status(status, NULL);
-	if (rc)
-		goto err;
-
 	pr_info("SEV supported\n");
 
-err:
-	kfree(status);
-	return rc;
+	return 0;
 }
 
 void sev_hardware_teardown(void)


