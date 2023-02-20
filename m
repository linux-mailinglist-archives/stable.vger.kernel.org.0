Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A13969CE37
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjBTN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjBTN5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:57:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDD41EBC8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:56:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A3860EAD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF4AC433D2;
        Mon, 20 Feb 2023 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901405;
        bh=Garq+V6wlxn2x6lwUMkJgHvCJib+Eqgs71CIXxuOjEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgG6YvCKaFdTseajE6ivEhZo2MD66TlSJFQpM+UciuVgPlakgqcec1DWZ79f0te8E
         Hd6jZgRc0l9OvSKPnkJn8S7Si3Ow+YEZHZ/vmZfp72+fvoij3PH8wXBzFQd4NAXoSl
         YhfCkN3Bg7E7w8fsCE518gCAKw0bMz7OCrjBobM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>,
        Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH 5.10 53/57] kvm: initialize all of the kvm_debugregs structure before sending it to userspace
Date:   Mon, 20 Feb 2023 14:37:01 +0100
Message-Id: <20230220133551.212102512@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 2c10b61421a28e95a46ab489fd56c0f442ff6952 upstream.

When calling the KVM_GET_DEBUGREGS ioctl, on some configurations, there
might be some unitialized portions of the kvm_debugregs structure that
could be copied to userspace.  Prevent this as is done in the other kvm
ioctls, by setting the whole structure to 0 before copying anything into
it.

Bonus is that this reduces the lines of code as the explicit flag
setting and reserved space zeroing out can be removed.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable <stable@kernel.org>
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4455,12 +4455,11 @@ static void kvm_vcpu_ioctl_x86_get_debug
 {
 	unsigned long val;
 
+	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
-	dbgregs->flags = 0;
-	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,


