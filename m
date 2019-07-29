Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2E7971C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390958AbfG2Tx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390954AbfG2Txz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB115204EC;
        Mon, 29 Jul 2019 19:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430035;
        bh=QVggB+xuFtwkbmgGs1TmoIKKalViLPWMe7q2bke1mag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylt0dSHXAeEIrdNgjIkoOoA4BX+01fxgCc4YcTMCAdJ7JX6/siHA+j31Q67LGSa/9
         EYYX0L8lY05quhwmMhsPRSiS5qoLo+tQW+pZKqeCfkDVQtLLOwc+5yDFyuq8UVI1g1
         J1zOOA9TCOMmTvT5Wiphi8xjBUUhNsAVlmiKoSpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 175/215] KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nesting
Date:   Mon, 29 Jul 2019 21:22:51 +0200
Message-Id: <20190729190810.318937160@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit 63279eeb7f93abb1692573c26f1e038e1a87358b upstream.

The performance monitoring unit (PMU) registers are saved on guest
exit when the guest has set the pmcregs_in_use flag in its lppaca, if
it exists, or unconditionally if it doesn't. If a nested guest is
being run then the hypervisor doesn't, and in most cases can't, know
if the PMU registers are in use since it doesn't know the location of
the lppaca for the nested guest, although it may have one for its
immediate guest. This results in the values of these registers being
lost across nested guest entry and exit in the case where the nested
guest was making use of the performance monitoring facility while it's
nested guest hypervisor wasn't.

Further more the hypervisor could interrupt a guest hypervisor between
when it has loaded up the PMU registers and it calling H_ENTER_NESTED
or between returning from the nested guest to the guest hypervisor and
the guest hypervisor reading the PMU registers, in
kvmhv_p9_guest_entry(). This means that it isn't sufficient to just
save the PMU registers when entering or exiting a nested guest, but
that it is necessary to always save the PMU registers whenever a guest
is capable of running nested guests to ensure the register values
aren't lost in the context switch.

Ensure the PMU register values are preserved by always saving their
value into the vcpu struct when a guest is capable of running nested
guests.

This should have minimal performance impact however any impact can be
avoided by booting a guest with "-machine pseries,cap-nested-hv=false"
on the qemu commandline.

Fixes: 95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190703012022.15644-1-sjitindarsingh@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3654,6 +3654,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
 		vcpu->arch.vpa.dirty = 1;
 		save_pmu = lp->pmcregs_in_use;
 	}
+	/* Must save pmu if this guest is capable of running nested guests */
+	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
 


