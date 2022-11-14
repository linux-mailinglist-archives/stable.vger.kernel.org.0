Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD35C6280C4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbiKNNJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbiKNNJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F67923BDD;
        Mon, 14 Nov 2022 05:08:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58BB0B80EB9;
        Mon, 14 Nov 2022 13:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFB0C433C1;
        Mon, 14 Nov 2022 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431335;
        bh=FnfRTOhpDMPdMpibKZbXNzOt6gJVf8lagElMLa9mf90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwpVmJb5bO3thJ3lMoRPWjpLiZSCj3CsCq7DPa9qjI0O1+1X5OZGUdTOiz5WwWAEe
         DP9QWTUg9VjrMxDrK0ouSEz9d1n58ahCP7vH9KqkrgCZ4Cmty34W8Gltkx5LMbBMUl
         9YRdQEdSfhTTv+Iw8sLhQKpuBeFnqwc7s2Lnv8oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Harald Hoyer <harald@profian.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6.0 170/190] KVM: SVM: Only dump VMSA to klog at KERN_DEBUG level
Date:   Mon, 14 Nov 2022 13:46:34 +0100
Message-Id: <20221114124506.283051703@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Peter Gonda <pgonda@google.com>

commit 0bd8bd2f7a789fe1dcb21ad148199d2f62d79873 upstream.

Explicitly print the VMSA dump at KERN_DEBUG log level, KERN_CONT uses
KERNEL_DEFAULT if the previous log line has a newline, i.e. if there's
nothing to continuing, and as a result the VMSA gets dumped when it
shouldn't.

The KERN_CONT documentation says it defaults back to KERNL_DEFAULT if the
previous log line has a newline. So switch from KERN_CONT to
print_hex_dump_debug().

Jarkko pointed this out in reference to the original patch. See:
https://lore.kernel.org/all/YuPMeWX4uuR1Tz3M@kernel.org/
print_hex_dump(KERN_DEBUG, ...) was pointed out there, but
print_hex_dump_debug() should similar.

Fixes: 6fac42f127b8 ("KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog")
Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Harald Hoyer <harald@profian.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Message-Id: <20221104142220.469452-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -605,7 +605,7 @@ static int sev_es_sync_vmsa(struct vcpu_
 	save->dr6  = svm->vcpu.arch.dr6;
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
-	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
+	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
 	return 0;
 }


