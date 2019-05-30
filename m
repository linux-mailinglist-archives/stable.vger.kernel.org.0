Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FC32F007
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbfE3D7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731574AbfE3DSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3BC9247D4;
        Thu, 30 May 2019 03:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186311;
        bh=jg3i/Q1qNmu17a97+l+Rkl3xirT3wgwiD63RXH7z14E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ez41Vvghh8IS5HMgP3fa9eRdTgRv5C38L+JIP93dlwyWln37W1AnA9TJSn+pqg+M4
         aUExhNDkd+Ex1gqF9KehdLlK2vaRctkMVnOIPHuLwPyj1CWlfAKAOz7dWfLHflhykJ
         OAZ1BspzB8shLomEQXinoUOL68PSFgKs173wtT1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 011/193] kvm: svm/avic: fix off-by-one in checking host APIC ID
Date:   Wed, 29 May 2019 20:04:25 -0700
Message-Id: <20190530030449.164544652@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
@@ -1567,7 +1567,11 @@ static void avic_vcpu_load(struct kvm_vc
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


