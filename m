Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0423A1720F7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgB0No4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbgB0Noz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:44:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 766ED24656;
        Thu, 27 Feb 2020 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811094;
        bh=pwJ+StcW9izmZqBwQ8Amym8xtuOTRPBbZU165E7EjN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsmDGYaNWfbhRZiqxRZnM4izyAN2eYsJFQIdzg4W3C/R1nB7W7AtlFkxhVGuiDODt
         0jZUJqFQqaeP1FopZ3cn5YS2CKO3nrm8UC84ruzgJb8Xuc15pfVOM0R7iaTCOa4KM5
         ZDT+3cKC2XoZ5WaonWlX5uiRjQQxpIkm7AeMHLw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 099/113] KVM: nVMX: Dont emulate instructions in guest mode
Date:   Thu, 27 Feb 2020 14:36:55 +0100
Message-Id: <20200227132227.594460803@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 07721feee46b4b248402133228235318199b05ec ]

vmx_check_intercept is not yet fully implemented. To avoid emulating
instructions disallowed by the L1 hypervisor, refuse to emulate
instructions by default.

Cc: stable@vger.kernel.org
[Made commit, added commit msg - Oliver]
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10759,7 +10759,7 @@ static int vmx_check_intercept(struct kv
 	}
 
 	/* TODO: check more intercepts... */
-	return X86EMUL_CONTINUE;
+	return X86EMUL_UNHANDLEABLE;
 }
 
 static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)


