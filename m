Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DED420F5D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhJDNeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237681AbhJDNc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B00961B97;
        Mon,  4 Oct 2021 13:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353281;
        bh=9i9/bVfxe+6AmXfvgRdDqZ4w6gYjUsBQXFnQotSu0IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ixXI9xWBL9tazy5KYBqny7VF8WLCb/G5N/jDTz7LtyiwbzmEtjJggjGcJXOof23+
         kFUS2aHARSWfUuHFf9Zqs7u1bmIiD1sqn5UjZPiHX0Dj9PsTmV5LQl0DmOWC2OSXC/
         20DW7vRBpfYaL51ns/KQkx4DX8XQp8nfxM903IKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, John Allen <john.allen@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 059/172] KVM: SVM: fix missing sev_decommission in sev_receive_start
Date:   Mon,  4 Oct 2021 14:51:49 +0200
Message-Id: <20211004125046.902566015@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingwei Zhang <mizhang@google.com>

commit f1815e0aa770f2127c5df31eb5c2f0e37b60fa77 upstream.

DECOMMISSION the current SEV context if binding an ASID fails after
RECEIVE_START.  Per AMD's SEV API, RECEIVE_START generates a new guest
context and thus needs to be paired with DECOMMISSION:

     The RECEIVE_START command is the only command other than the LAUNCH_START
     command that generates a new guest context and guest handle.

The missing DECOMMISSION can result in subsequent SEV launch failures,
as the firmware leaks memory and might not able to allocate more SEV
guest contexts in the future.

Note, LAUNCH_START suffered the same bug, but was previously fixed by
commit 934002cd660b ("KVM: SVM: Call SEV Guest Decommission if ASID
binding fails").

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210912181815.3899316-1-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1405,8 +1405,10 @@ static int sev_receive_start(struct kvm
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,


