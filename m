Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29E642699E
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242015AbhJHLjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242545AbhJHLiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D854161501;
        Fri,  8 Oct 2021 11:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692784;
        bh=3FPAyprHSVk9tz0yKyeSQh93KWN6UtSPS7XfaaRtOSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwNyGFItwDAGp8oNxuUhmfDklyg8pxt9u14tLi8bnLDyc8JcQHSrWyLZE4ZpPdSQp
         /lHNJDaSPX0JwtUgkW1SjYi8UUO5p/dTpIvHyAn0LeyzKIPAGnlCFdFdXfo+Zf+bOO
         vIAucq11o62QtgAbHJsOcZIl8CeAzgYE11bK89wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 44/48] KVM: x86: nSVM: restore int_vector in svm_clear_vintr
Date:   Fri,  8 Oct 2021 13:28:20 +0200
Message-Id: <20211008112721.518205911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit aee77e1169c1900fe4248dc186962e745b479d9e ]

In svm_clear_vintr we try to restore the virtual interrupt
injection that might be pending, but we fail to restore
the interrupt vector.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210914154825.104886-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1601,6 +1601,8 @@ static void svm_clear_vintr(struct vcpu_
 
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
 			V_IRQ_INJECTION_BITS_MASK;
+
+		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);


