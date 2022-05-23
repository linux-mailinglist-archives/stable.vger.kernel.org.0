Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D58C531AA4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbiEWRj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243146AbiEWRhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311A7A47E;
        Mon, 23 May 2022 10:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3AFCB81201;
        Mon, 23 May 2022 17:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240C6C34115;
        Mon, 23 May 2022 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327001;
        bh=EpJkC7kTnHmaFTqFlnkMeVZeMzfMC+I02j0S0pN1mms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h61YY2SMxxabvj++fqHFAQD08YONpvAnYidq0LfHiHzVxv7Gbc1dk4CmEt6CPFzoN
         N6yvswW0YxYEA7Sjjjb/R2pbweXrxVqyB9/ydTrvJCrUGNmWRTYB2M8tyEi8g/tDvo
         z3myaVj88QkQrfGZd4W/bcaJwbJ/auWRUKmPBqoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 124/158] kvm: x86/pmu: Fix the compare function used by the pmu event filter
Date:   Mon, 23 May 2022 19:04:41 +0200
Message-Id: <20220523165851.232347554@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

[ Upstream commit 4ac19ead0dfbabd8e0bfc731f507cfb0b95d6c99 ]

When returning from the compare function the u64 is truncated to an
int.  This results in a loss of the high nybble[1] in the event select
and its sign if that nybble is in use.  Switch from using a result that
can end up being truncated to a result that can only be: 1, 0, -1.

[1] bits 35:32 in the event select register and bits 11:8 in the event
    select.

Fixes: 7ff775aca48ad ("KVM: x86/pmu: Use binary search to check filtered events")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220517051238.2566934-1-aaronlewis@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eca39f56c231..0604bc29f0b8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -171,9 +171,12 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
-static int cmp_u64(const void *a, const void *b)
+static int cmp_u64(const void *pa, const void *pb)
 {
-	return *(__u64 *)a - *(__u64 *)b;
+	u64 a = *(u64 *)pa;
+	u64 b = *(u64 *)pb;
+
+	return (a > b) - (a < b);
 }
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
-- 
2.35.1



