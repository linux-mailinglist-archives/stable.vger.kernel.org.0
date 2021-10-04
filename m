Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C65420F7E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbhJDNf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237888AbhJDNdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E816322D;
        Mon,  4 Oct 2021 13:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353309;
        bh=z6mYA0ABvX36KU1qCO5fuQKeKIbVOqQUA7VW++61n0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfoMA3tq7Kq/U/AHCzflCt05vrIGZmCpF8O2uG/YX/pqguK5sdazK0VewBN9OdXIs
         ICRgzPgoNq8a+XShrEekRnYlNqzP59a+tNoVb2b2A/k9pRSLfbsPXWcZ9jJhK02usB
         MzEqeUZ0KJmrOGI9EI1V8aFfOo2lViogjTnWPDT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 060/172] KVM: nVMX: Fix nested bus lock VM exit
Date:   Mon,  4 Oct 2021 14:51:50 +0200
Message-Id: <20211004125046.933779243@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

commit 24a996ade34d00deef5dee2c33aacd8fda91ec31 upstream.

Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
VM exit, it will be directed to L1 VMM, which would cause unexpected
behavior. Therefore, handle L2's bus lock VM exits in L0 directly.

Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-Id: <20210914095041.29764-1-chenyi.qiang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5898,6 +5898,12 @@ static bool nested_vmx_l0_wants_exit(str
 	case EXIT_REASON_VMFUNC:
 		/* VM functions are emulated through L2->L0 vmexits. */
 		return true;
+	case EXIT_REASON_BUS_LOCK:
+		/*
+		 * At present, bus lock VM exit is never exposed to L1.
+		 * Handle L2's bus locks in L0 directly.
+		 */
+		return true;
 	default:
 		break;
 	}


