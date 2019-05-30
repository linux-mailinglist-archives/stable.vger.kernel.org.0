Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BEF2EC68
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbfE3DUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732272AbfE3DUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B3824953;
        Thu, 30 May 2019 03:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186438;
        bh=GVUOogKLufmpvD7m1tZ21GFHKFy8jpve9Uw8hXJ6jGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRg4NLskuUAh5O89UTtYtGMSlKhhBh30rIn71NnW5s2696tFm0XGaTz/67q49CN1C
         EGRZtffgcDRjKk3SvEDMOR8L+CdKYm6zvqPLkgM/6kgaqmwvoVdvff50IhpJUQ3D+s
         hmr0r9K5ifr6/b436iYzEYdH35GmXv/vqYgEH8VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 006/128] kvm: svm/avic: fix off-by-one in checking host APIC ID
Date:   Wed, 29 May 2019 20:05:38 -0700
Message-Id: <20190530030434.416705883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suthikulpanit, Suravee <Suravee.Suthikulpanit@amd.com>

commit c9bcd3e3335d0a29d89fabd2c385e1b989e6f1b0 upstream.

Current logic does not allow VCPU to be loaded onto CPU with
APIC ID 255. This should be allowed since the host physical APIC ID
field in the AVIC Physical APIC table entry is an 8-bit value,
and APIC ID 255 is valid in system with x2APIC enabled.
Instead, do not allow VCPU load if the host APIC ID cannot be
represented by an 8-bit value.

Also, use the more appropriate AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK
instead of AVIC_MAX_PHYSICAL_ID_COUNT.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1518,7 +1518,11 @@ static void avic_vcpu_load(struct kvm_vc
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	if (WARN_ON(h_physical_id >= AVIC_MAX_PHYSICAL_ID_COUNT))
+	/*
+	 * Since the host physical APIC id is 8 bits,
+	 * we can support host APIC ID upto 255.
+	 */
+	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));


