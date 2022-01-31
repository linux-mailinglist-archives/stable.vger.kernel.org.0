Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7B4A441D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359638AbiAaL0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358626AbiAaLVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:21:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C0EC0797A9;
        Mon, 31 Jan 2022 03:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CCF8B82A66;
        Mon, 31 Jan 2022 11:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC25BC340E8;
        Mon, 31 Jan 2022 11:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627648;
        bh=dM3iea27OHICyc17xNvr5LK/MG0brUjiMVVrlnGqQ5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TB+9gBIr5r0oMlsJH6L+xt3THgvDvs2CqnZ8W42NGiegAe7HF2v479ySfWdFtRb+G
         bYtwgJEIGE9BBbMAAJxgDgsHjvoaiuCHep4bFpGyF3J2vGeJY3Kz1d2yl185lw0pJq
         yED0aIFci55Lf1UoEyPaEtu4n7CvSoNfWJWS4K/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/171] KVM: selftests: Dont skip L2s VMCALL in SMM test for SVM guest
Date:   Mon, 31 Jan 2022 11:56:57 +0100
Message-Id: <20220131105235.157600309@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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



