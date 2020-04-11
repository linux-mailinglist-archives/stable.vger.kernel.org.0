Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E365E1A5506
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgDKXIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgDKXIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8788021BE5;
        Sat, 11 Apr 2020 23:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646533;
        bh=bha6suG23kLCQTf2cY4Opk4WKpHiAl1++/qRyb7g8yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RX0C7ujiwNlU1yAGdlI8g5HOmVQh75df+WOWUeMiIDwk754z3AHdla10Yp73pROWl
         avH97D03XT6mMOxckNhXGL2SzG4tY6pbG6QVZowmaWdfqvrQuBxjOEAYuyKeHSfgvu
         7TnvZLpAToxy4yOgJM3UwyuHdWckvms4wbfzt/o4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ram Pai <linuxram@us.ibm.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 087/121] KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN
Date:   Sat, 11 Apr 2020 19:06:32 -0400
Message-Id: <20200411230706.23855-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 377f02d487b5f74a2411fa01316ba4aff1819629 ]

When the call to UV_REGISTER_MEM_SLOT is failing, for instance because
there is not enough free secured memory, the Hypervisor (HV) has to call
UV_RETURN to report the error to the Ultravisor (UV). Then the UV will call
H_SVM_INIT_ABORT to abort the securing phase and go back to the calling VM.

If the kvm->arch.secure_guest is not set, in the return path rfid is called
but there is no valid context to get back to the SVM since the Hcall has
been routed by the Ultravisor.

Move the setting of kvm->arch.secure_guest earlier in
kvmppc_h_svm_init_start() so in the return path, UV_RETURN will be called
instead of rfid.

Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Tested-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 5914fbfa5e0a7..8accba2d39bc4 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -209,6 +209,8 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	int ret = H_SUCCESS;
 	int srcu_idx;
 
+	kvm->arch.secure_guest = KVMPPC_SECURE_INIT_START;
+
 	if (!kvmppc_uvmem_bitmap)
 		return H_UNSUPPORTED;
 
@@ -233,7 +235,6 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 			goto out;
 		}
 	}
-	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_START;
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
-- 
2.20.1

