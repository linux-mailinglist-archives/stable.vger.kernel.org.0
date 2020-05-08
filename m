Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD41CACCB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgEHM4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbgEHM4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:56:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9282054F;
        Fri,  8 May 2020 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942562;
        bh=ggRepalI9rxSZiHeWYpAhYBIqtEyUblOEGC0s7+G0Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW4cRIDJJ6wiH5Oh9FAOFGJvrk3rRUfunoBdUIVbWoY+WxAkHY4BlD3SbWICiiZ8f
         HClrEL0yfv0OgkVakmp1cKH42mBLb3Oe0dBvuAD/yCGpdyc5MfZVEFXYj9SAlfWHMd
         8dxS91qXbtORLFUUn6xFOpe54nVaLlbVPWRJGdnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 44/49] x86/kvm: fix a missing-prototypes "vmread_error"
Date:   Fri,  8 May 2020 14:36:01 +0200
Message-Id: <20200508123049.001191211@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 514ccc194971d0649e4e7ec8a9b3a6e33561d7bf upstream.

The commit 842f4be95899 ("KVM: VMX: Add a trampoline to fix VMREAD error
handling") removed the declaration of vmread_error() causes a W=1 build
failure with KVM_WERROR=y. Fix it by adding it back.

arch/x86/kvm/vmx/vmx.c:359:17: error: no previous prototype for 'vmread_error' [-Werror=missing-prototypes]
 asmlinkage void vmread_error(unsigned long field, bool fault)
                 ^~~~~~~~~~~~

Signed-off-by: Qian Cai <cai@lca.pw>
Message-Id: <20200402153955.1695-1-cai@lca.pw>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/ops.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -12,6 +12,7 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
 							 bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);


