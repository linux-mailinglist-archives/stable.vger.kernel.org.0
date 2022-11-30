Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBDB63DEBC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiK3SkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiK3SkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE12D97021
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7830F61D61
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87424C433D7;
        Wed, 30 Nov 2022 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833611;
        bh=/dbgTvWo33goEaOSymjCLg5CDw/PZfpG2fvpuDNfdpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpC1J/cxwE3it8nbIQGZ6czoBJjcWRWyFPF+DDqUIkedUYo4xxHEq9q5p2iSJ1msR
         xEV6mCvnTGx0O6ddoteKjA4QcVoXn1dcFbOpxc5Miw925Vw6e6VzjMJBmv3TcmV7Yc
         tHzxnK8UC0zO+p9gzGDCRH/+6fhN0pksIYwCUHK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 158/206] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use
Date:   Wed, 30 Nov 2022 19:23:30 +0100
Message-Id: <20221130180537.053175220@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 16ae56d7e0528559bf8dc9070e3bfd8ba3de80df upstream.

Make sure that KVM uses vmcb01 before freeing nested state, and warn if
that is not the case.

This is a minimal fix for CVE-2022-3344 making the kernel print a warning
instead of a kernel panic.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-3-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -919,6 +919,9 @@ void svm_free_nested(struct vcpu_svm *sv
 	if (!svm->nested.initialized)
 		return;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
+		svm_switch_vmcb(svm, &svm->vmcb01);
+
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 


