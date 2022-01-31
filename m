Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BBE4A44AA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350770AbiAaLcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378760AbiAaL3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EC2C0613EB;
        Mon, 31 Jan 2022 03:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44B96B82A5D;
        Mon, 31 Jan 2022 11:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61257C340E8;
        Mon, 31 Jan 2022 11:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627887;
        bh=mpfgD1264nYsnAM995Tl4rURc0002SYu7qwTBFLX8qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xh35EZ76+cFeXz0z1qagsa9YqjC1k3irkx7oXADKnnX7RoxQ9nqp7nmhaAZiLHm0I
         6w1UuvOI/Y4o/yu27IKoSsYiLaZcwBLVS0csRnxREVjbF0n8HGSpiZZy22UB13BIIA
         w4Gf7o8oNiLJmqFmhcoEA22smESAjr13RgkfBUqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 055/200] KVM: x86: Check .flags in kvm_cpuid_check_equal() too
Date:   Mon, 31 Jan 2022 11:55:18 +0100
Message-Id: <20220131105235.429648995@linuxfoundation.org>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 033a3ea59a19df63edb4db6bfdbb357cd028258a upstream.

kvm_cpuid_check_equal() checks for the (full) equality of the supplied
CPUID data so .flags need to be checked too.

Reported-by: Sean Christopherson <seanjc@google.com>
Fixes: c6617c61e8fe ("KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220126131804.2839410-1-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -113,6 +113,7 @@ static int kvm_cpuid_check_equal(struct
 		orig = &vcpu->arch.cpuid_entries[i];
 		if (e2[i].function != orig->function ||
 		    e2[i].index != orig->index ||
+		    e2[i].flags != orig->flags ||
 		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
 		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
 			return -EINVAL;


