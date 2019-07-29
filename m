Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68B3796DB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390568AbfG2T4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404265AbfG2T4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:56:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474AA204EC;
        Mon, 29 Jul 2019 19:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430163;
        bh=XRSDJcvmHaQSZCMe638gYg9xJlsKDcJ71p0J4mZtS3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnAYMdLlE9pP54xvOkYBvCbAaDCqYAQENZl+ywKI1fzUtD1cnUdEz/pbWgp3PZzwP
         RMSESNEuTXtXyqiRe39F0BvdnkiqsmucvtV3wCR1CU96P+Eeu1cKF/yTti9f3mZHKb
         Pqf6RaNB0L/gEH+6Y5WAMrF/uTguJHklKyYyzX3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 200/215] powerpc/pmu: Set pmcregs_in_use in paca when running as LPAR
Date:   Mon, 29 Jul 2019 21:23:16 +0200
Message-Id: <20190729190814.579910296@linuxfoundation.org>
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

commit 28d2a6e6684d9851905f379816d8a4d03587ed94 upstream.

The ability to run nested guests under KVM means that a guest can also
act as a hypervisor for it's own nested guest. Currently
ppc_set_pmu_inuse() assumes that either FW_FEATURE_LPAR is set,
indicating a guest environment, and so sets the pmcregs_in_use flag in
the lppaca, or that it isn't set, indicating a hypervisor environment,
and so sets the pmcregs_in_use flag in the paca.

The pmcregs_in_use flag in the lppaca is used to communicate this
information to a hypervisor and so must be set in a guest environment.
The pmcregs_in_use flag in the paca is used by KVM code to determine
whether the host state of the performance monitoring unit (PMU) must
be saved and restored when running a guest.

Thus when a guest also acts as a hypervisor it must set this bit in
both places since it needs to ensure both that the real hypervisor
saves it's PMU registers when it runs (requires pmcregs_in_use flag in
lppaca), and that it saves it's own PMU registers when running a
nested guest (requires pmcregs_in_use flag in paca).

Modify ppc_set_pmu_inuse() so that the pmcregs_in_use bit is set in
both the lppaca and the paca when a guest (LPAR) is running with the
capability of running it's own guests (CONFIG_KVM_BOOK3S_HV_POSSIBLE).

Fixes: 95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190703012022.15644-2-sjitindarsingh@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/pmc.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -27,11 +27,10 @@ static inline void ppc_set_pmu_inuse(int
 #ifdef CONFIG_PPC_PSERIES
 		get_lppaca()->pmcregs_in_use = inuse;
 #endif
-	} else {
+	}
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-		get_paca()->pmcregs_in_use = inuse;
+	get_paca()->pmcregs_in_use = inuse;
 #endif
-	}
 #endif
 }
 


