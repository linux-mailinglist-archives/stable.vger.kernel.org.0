Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36D554CA2
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 12:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfFYKqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 06:46:25 -0400
Received: from mout.web.de ([212.227.15.4]:40021 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfFYKqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 06:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561459526;
        bh=jg0LNFsCwDmqXuZh9IGxLcaasuGMXo9WkaIpQDF3y/A=;
        h=X-UI-Sender-Class:Date:From:Subject:To:CC:In-Reply-To;
        b=VJhNwqUxb0kzahw31C4IToRfsvI0o7P9m93tzY2VZit14pHh+3MMPPSZ6w32Dl3wc
         t8LYeooXufVGoTFTYW4rfom7Wwozcnw8kypOhTo0uiF++cj3/ZnJrzFZQDJEZN5F5K
         4Kwj3v055M2rw3OoBNcP3RLdp6hjnt83sGGht4Fc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from debian ([85.71.157.74]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M2us2-1iXxzs0Tos-00seXr; Tue, 25
 Jun 2019 12:45:26 +0200
Date:   Tue, 25 Jun 2019 12:45:24 +0200
Message-Id: <87mui6djuj.fsf@debian>
From:   Jiri Palecek <jpalecek@web.de>
Subject: [PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit
 NPT
To:     stable@vger.kernel.org
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1561321670157164@kroah.com>
X-Provags-ID: V03:K1:1y6XoTj4Vgoe7h9Os0KjfBvSjT40hPau6CZwWOlVZlQhWvvyFoK
 HsUJrEQ+SY+Ylapa8jbK34KE1TYIHE4fYa0A1o1EyOp5yOBKALM/uwMn+H8mB3SQAp8vPvd
 L3HHtegqfVGSetIUpV1DrC9HKRZ9RKeW0YMi4vpmeRmg4k1JRu0U135nvuc7Neb/lTRTcCz
 Rr2LXsbUZm5ZdCYH2wRqQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OLindXxU994=:Mhg8vw0g8VXdmhHSTbwn3w
 F3EFmFWPKA2St4JKpRQjETkzkgNs7m0jzVoJNTm8mGvwsuWEM+1IQZfodHa07S7Cg4r3CU1lP
 usFDiAWT5/APpYt5b9vDgpXWbbIzX/qvzFUX1J6q01RjDWzyO4XbTacBcCi1szOS3Q6ai+C5D
 +SBEWzn5ItDC9mFk2Csgw9mUZ2xfmjMAStK0vzWMRU2DeITacDgq+33pTC28S7P5Kq2o7Q4yU
 iiLv5K0tmHk6du+Iky8Aa5Z2g1idiVcDl8fYfGA1bp3PcacHtmBPXY2YiIHI2Bh33woEQMzZs
 78llDjqdkxdd+557RytNRMeMCcmEWyBUDVN/Mv3CVKWJofajazjfjh09yLJSgk3YXQoloOzll
 FzWLu46o1lu8+MywSoJKeRA1YzOpfCX12fgURrglNE4agQ+R7cZpDdhIZlB7tsdRSSDIhMEyb
 28kCblWxJOkVEA4ZyFWPSPxc+uD1f0cOia4MazJVA7V4SYGxC1VmZhv5+ih1cBXfnYkz2gfOg
 G4hI1nLAYq2xhMQ7aViMJTZ6ssIRyNWSzsgbd+4eJjRgLVg3dUkahjKSXyvnKKLyplWDKP9b0
 wtse+wnYsIVdWzJaEq/71DqbRU/e29qQNCLM+PJUGbLPZDHR9n6oOOJiIK2pHKK6d/sxtoLyo
 LkGoNK0/A0scQ/7F/q2tiHx91qpPmDj3cIIsSffZJPSKSBZa8SpOVdlFeg2Tp8s2SJs4YWNan
 L1aV4fJX4/8jeBkRTuYw+SL0BwzJI5WX6/lQGZiptgO142jfd5FPnJDJKPJjKvTswuRYbiLo9
 cZdewTksCFW9tVBWzF2EUPpLFzuPtbO4K9iSCdZuGo34KW7Q0fJsT+pSntezUrkchWozeHMvI
 +wiOauvtdjUIdsKBBfM3AmZQ6P9OBxBaRib4htgQFxfUoiGKBCAldj0ojBZvV93TENkor4ncN
 vehiUEqgApC6bHxlZdFo9uhKJ5S0ciL0=
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Original commit id b6b80c78 ported to stable/linux-4.19.y.

SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
is enabled, i.e. the PAE root array needs to be allocated.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp ena=
bled")
Cc: stable@vger.kernel.org
Reported-by: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
=2D--
 arch/x86/kvm/mmu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 779ed52047d1..e0f982e35c96 100644
=2D-- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5386,7 +5386,16 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int i;

-	if (tdp_enabled)
+	/*
+	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
+	 * while the PDP table is a per-vCPU construct that's allocated at MMU
+	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
+	 * x86_64.  Therefore we need to allocate the PDP table in the first
+	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
+	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
+	 * skip allocating the PDP table.
+	 */
+	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;

 	/*
=2D-
2.20.1

