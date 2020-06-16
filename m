Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C7D1FB9B4
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732192AbgFPPs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732413AbgFPPs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D426720776;
        Tue, 16 Jun 2020 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322506;
        bh=zZwRYPHfxPr8Xw3EHAcsqmAxXoL1FwvL9a3v8YWMs3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pz9l2uzW/obvbNgy/YCW0hx28B97tYcLZbAj2ZaMFbDheW/g3Fg11SwG7RA8fcH4
         KMuVTHF6QkkDmEjqxSgPsmk0N2kkHE3dnMLde4+rz4oYLOsUZ5O+Rj88VqNfzwAioi
         H9pm8IOB7aWSu+bev3Y9kVPqNpm+Mzd5lb0sG1BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.7 129/163] KVM: nSVM: leave ASID aside in copy_vmcb_control_area
Date:   Tue, 16 Jun 2020 17:35:03 +0200
Message-Id: <20200616153112.993856959@linuxfoundation.org>
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

commit 6c0238c4a62b3a0b1201aeb7e33a4636d552a436 upstream.

Restoring the ASID from the hsave area on VMEXIT is wrong, because its
value depends on the handling of TLB flushes.  Just skipping the field in
copy_vmcb_control_area will do.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm/nested.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -150,7 +150,7 @@ static void copy_vmcb_control_area(struc
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
-	dst->asid                 = from->asid;
+	/* asid not copied, it is handled manually for svm->vmcb.  */
 	dst->tlb_ctl              = from->tlb_ctl;
 	dst->int_ctl              = from->int_ctl;
 	dst->int_vector           = from->int_vector;


