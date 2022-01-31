Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2EC4A4421
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350316AbiAaL0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42024 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378454AbiAaLY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 032C5B82A5D;
        Mon, 31 Jan 2022 11:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9F4C340E8;
        Mon, 31 Jan 2022 11:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628265;
        bh=dM3iea27OHICyc17xNvr5LK/MG0brUjiMVVrlnGqQ5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nE7JDjvi/KdCalM7eGduQZ0tKg14v7G4xp6XsrC+/1/usLO/O+ki2SKfum/SqwgH8
         RbNa08DIkMmHXDmMfOUCTnzO6xolFMboy3/+L9Y6U2ENRu+UrGge9Iwqr/K6TUrPJK
         wnU1+hFa221MeGZwmsFHJM09F5A0L6lN2q8xyjpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 178/200] KVM: selftests: Dont skip L2s VMCALL in SMM test for SVM guest
Date:   Mon, 31 Jan 2022 11:57:21 +0100
Message-Id: <20220131105239.536898422@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 4cf3d3ebe8794c449af3e0e8c1d790c97e461d20 ]

Don't skip the vmcall() in l2_guest_code() prior to re-entering L2, doing
so will result in L2 running to completion, popping '0' off the stack for
RET, jumping to address '0', and ultimately dying with a triple fault
shutdown.

It's not at all obvious why the test re-enters L2 and re-executes VMCALL,
but presumably it serves a purpose.  The VMX path doesn't skip vmcall(),
and the test can't possibly have passed on SVM, so just do what VMX does.

Fixes: d951b2210c1a ("KVM: selftests: smm_test: Test SMM enter from L2")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220125221725.2101126-1-seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index d0fe2fdce58c4..db2a17559c3d5 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -105,7 +105,6 @@ static void guest_code(void *arg)
 
 		if (cpu_has_svm()) {
 			run_guest(svm->vmcb, svm->vmcb_gpa);
-			svm->vmcb->save.rip += 3;
 			run_guest(svm->vmcb, svm->vmcb_gpa);
 		} else {
 			vmlaunch();
-- 
2.34.1



