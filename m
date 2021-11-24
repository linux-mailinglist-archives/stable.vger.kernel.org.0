Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE645C5E1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350995AbhKXOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350923AbhKXN7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:59:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 855136023D;
        Wed, 24 Nov 2021 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759335;
        bh=+rYI7CaTuDUM2iDJU+SQR0WZR+OIzM4MpB8gfZR/oi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTgxmK+SkZguoMCwokfCdpwHX6eejkQlsEw7OyBIU08E+dKxI9KrHRUXZv6c+C+4X
         Hy/2VnPP+5WkTlyjhu32Y9KB6pGewwOLCsY0Z6mktRdeZfYjfDnZKr1zn+XzSHyQaE
         enoYUrU4214IVvVOR6j+RVep/7VVHsVLoWwqTYSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 207/279] KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO
Date:   Wed, 24 Nov 2021 12:58:14 +0100
Message-Id: <20211124115725.893862984@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit 4e8436479ad3be76a3823e6ce466ae464ce71300 upstream.

In commit 319afe68567b ("KVM: xen: do not use struct gfn_to_hva_cache") we
stopped storing this in-kernel as a GPA, and started storing it as a GFN.
Which means we probably should have stopped calling gpa_to_gfn() on it
when userspace asks for it back.

Cc: stable@vger.kernel.org
Fixes: 319afe68567b ("KVM: xen: do not use struct gfn_to_hva_cache")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <20211115165030.7422-2-dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -299,7 +299,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_gfn);
+		data->u.shared_info.gfn = kvm->arch.xen.shinfo_gfn;
 		r = 0;
 		break;
 


