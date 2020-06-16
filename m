Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD281FBAAC
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbgFPPnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbgFPPng (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D62D214DB;
        Tue, 16 Jun 2020 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322216;
        bh=sfnXnmZgiyRdrCage/CzeX/k/dTX96/ogyuFgEub200=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4pYbZN5rcSUihtnW1z0Tcp9aeBTJ3I1XthVGQmKyc9e6jYzSuIiBMUXQOrO8vlKM
         CqLdvH/1PpO5xxJ0IStBtlB8owLvFcqzEpBg2j2UscLvZofqv104tSCvIb251U94ME
         WIFhN8AQrHukTxiPCcnQJaYiTp2Y/88TnNVdC9p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.7 045/163] KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
Date:   Tue, 16 Jun 2020 17:33:39 +0200
Message-Id: <20200616153109.018122346@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit df2a69af85bef169ab6810cc57f6b6b943941e7e upstream.

The migration functionality was left incomplete in commit 5ef8acbdd687
("KVM: nVMX: Emulate MTF when performing instruction emulation", 2020-02-23),
fix it.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4586,7 +4586,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 
 		if (kvm_state.flags &
 		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
-		      | KVM_STATE_NESTED_EVMCS))
+		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
 			break;
 
 		/* nested_run_pending implies guest_mode.  */


