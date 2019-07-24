Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC2173950
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbfGXTjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbfGXTjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D570E20665;
        Wed, 24 Jul 2019 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997147;
        bh=Bn01p6f4dJ+UG76o1+0Rtg6qiDDghmkM6c0UTczyLIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDuzIWgPPkNoG61Vg/e5pVzLihpTtJI2kqGNpcRcGoUtFAHCclG908X4UW4mOIvxi
         qW9/jEqsNY+eej4YE/JN91xqGc93903JaKndef4US2sgNEs3GzBTHuL+op5aI4WGqk
         gFvjAszAhhINRbca/AKi89ZG9mcASESEs+bH5/4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 335/413] KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
Date:   Wed, 24 Jul 2019 21:20:26 +0200
Message-Id: <20190724191759.797865671@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

commit 6fc3977ccc5d3c22e851f2dce2d3ce2a0a843842 upstream.

If a perf_event creation fails due to any reason of the host perf
subsystem, it has no chance to log the corresponding event for guest
which may cause abnormal sampling data in guest result. In debug mode,
this message helps to understand the state of vPMC and we may not
limit the number of occurrences but not in a spamming style.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/pmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -128,8 +128,8 @@ static void pmc_reprogram_counter(struct
 						 intr ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
-		printk_once("kvm_pmu: event creation failed %ld\n",
-			    PTR_ERR(event));
+		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
+			    PTR_ERR(event), pmc->idx);
 		return;
 	}
 


