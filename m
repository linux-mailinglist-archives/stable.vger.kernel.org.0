Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C7D1390C
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfEDK0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbfEDK0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 309BB20859;
        Sat,  4 May 2019 10:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965590;
        bh=y7eIOfRWIMAAfniG9cWwpHWvZj9HvBWQy/hZ1FvcB2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yLvglB2aMcJLAIdKx4v1Eh8ivanwMbkGIYbkC6Y/xdjUL/VUABSYm9NDhHKEoAek
         1CmYSFd44lLJ8GBN1ZEFNrOSIkcWHa/lt1/Xp/DHY9Md84it5Xx6mZvqF80qP7zztA
         j5VJZTo7mnY07BNFBJTI0OjZTXauXEWTNmqZc6bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Wilhelm <fwilhelm@google.com>,
        Jim Mattson <jmattson@google.com>,
        Drew Schmitt <dasch@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        stable@ver.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 29/32] KVM: nVMX: Fix size checks in vmx_set_nested_state
Date:   Sat,  4 May 2019 12:25:14 +0200
Message-Id: <20190504102453.374211973@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit e8ab8d24b488632d07ce5ddb261f1d454114415b upstream.

The size checks in vmx_nested_state are wrong because the calculations
are made based on the size of a pointer to a struct kvm_nested_state
rather than the size of a struct kvm_nested_state.

Reported-by: Felix Wilhelm  <fwilhelm@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Drew Schmitt <dasch@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Fixes: 8fcc4b5923af5de58b80b53a069453b135693304
Cc: stable@ver.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5407,7 +5407,7 @@ static int vmx_set_nested_state(struct k
 		return ret;
 
 	/* Empty 'VMXON' state is permitted */
-	if (kvm_state->size < sizeof(kvm_state) + sizeof(*vmcs12))
+	if (kvm_state->size < sizeof(*kvm_state) + sizeof(*vmcs12))
 		return 0;
 
 	if (kvm_state->vmx.vmcs_pa != -1ull) {
@@ -5451,7 +5451,7 @@ static int vmx_set_nested_state(struct k
 	    vmcs12->vmcs_link_pointer != -1ull) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
 
-		if (kvm_state->size < sizeof(kvm_state) + 2 * sizeof(*vmcs12))
+		if (kvm_state->size < sizeof(*kvm_state) + 2 * sizeof(*vmcs12))
 			return -EINVAL;
 
 		if (copy_from_user(shadow_vmcs12,


