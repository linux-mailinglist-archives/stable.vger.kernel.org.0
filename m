Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EDF7F47D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389963AbfHBJcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391197AbfHBJcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:32:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22FE217F5;
        Fri,  2 Aug 2019 09:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738341;
        bh=SOHZCKy37fs3IqoZ36GSFFZphzMehdE9/WH9M3jnfJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTCJJ6Qy91w5jZpD1BVb+WeY9CASsAPuarlNcr+JsxiSd5LW1ZNTqfNXiiVtp1Or9
         OIxiZFy5fwrzIgVMgEHROO1KBPTyP3BuPkI4LvJCxhzrtn1+c0Rf9eG8QJwOmR0asT
         SHNVEuvoZos5gQO1/vxzYvoWedYOMZojMfPZ3whE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 066/158] KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
Date:   Fri,  2 Aug 2019 11:28:07 +0200
Message-Id: <20190802092217.488284216@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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
@@ -124,8 +124,8 @@ static void pmc_reprogram_counter(struct
 						 intr ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
-		printk_once("kvm_pmu: event creation failed %ld\n",
-			    PTR_ERR(event));
+		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
+			    PTR_ERR(event), pmc->idx);
 		return;
 	}
 


