Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8163900B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbfFGPsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731152AbfFGPsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0DAA2147A;
        Fri,  7 Jun 2019 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922500;
        bh=ET5qG1XoF3OZACkbA9mNkVFZr/Isn+mUK3xZc6ixKhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxJn9ERw4OvfBJ8jnhl7X2o+Fud0ymsQe2nRhN31XX1miwD3xCDOgVQcvJlGWMat5
         WaUZdS1eBqaj3/YnoZjK5/BUCXRWrDOs3hY10cRSuaYn9MvJ/E5TldVGfj9TNoGyDF
         u2FrF0tgUqwqxA2rLu+tayVHBDnTXrnjoSq9f/aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.1 36/85] KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry()
Date:   Fri,  7 Jun 2019 17:39:21 +0200
Message-Id: <20190607153853.721213391@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit d724c9e54939a597592de3659541da11fc7aa112 upstream.

The sprgs are a set of 4 general purpose sprs provided for software use.
SPRG3 is special in that it can also be read from userspace. Thus it is
used on linux to store the cpu and numa id of the process to speed up
syscall access to this information.

This register is overwritten with the guest value on kvm guest entry,
and so needs to be restored on exit again. Thus restore the value on
the guest exit path in kvmhv_p9_guest_entry().

Cc: stable@vger.kernel.org # v4.20+
Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3624,6 +3624,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
 	vc->in_guest = 0;
 
 	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
 


