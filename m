Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94A842695C
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbhJHLgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241270AbhJHLeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 302FA61139;
        Fri,  8 Oct 2021 11:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692684;
        bh=iDuXUh8Sqb2SmjrONaN8Y8dFcYOdWd+BO/L8fjufths=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtgfHPkGxhfTJn/o3E3hJoP5xsPpwjB8V/HBeRBcP7LPYhAJ9EEpUephiJB0/QUJk
         rRmArqq4Gp/ROI1hO+Dt9i9fK+eKfteHtkhKt+JxyNFzUEhqMJYmS/GgCPnbRJsMac
         Yt040d6WM/cuJ2ydC/7OEKFQYMFkgiz5JWVOSBTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/29] KVM: x86: nSVM: restore int_vector in svm_clear_vintr
Date:   Fri,  8 Oct 2021 13:28:14 +0200
Message-Id: <20211008112717.885608463@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
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
 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1c23aee3778c..5e1d7396a6b8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1497,6 +1497,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
 			V_IRQ_INJECTION_BITS_MASK;
+
+		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.33.0



