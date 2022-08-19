Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4DD59A34F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354212AbiHSQwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354645AbiHSQv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:51:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02741156FD;
        Fri, 19 Aug 2022 09:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF8B9B8280D;
        Fri, 19 Aug 2022 16:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA9BC433D6;
        Fri, 19 Aug 2022 16:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925615;
        bh=WbEMAlrawh08q0dXgHD22Zl1G6evzjYEaZ+pVq1Yp3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWHu1/ExxdPFOoelkl8QV1P5BV+AToHosGjfL455es+BifeaUpb+VAoXnRty6/Rvq
         KAtvl8kKvNMcw8s3sQw/PbATtjqaBbEmAd3Lr347js/k4qGVWcaWa8NSNeWRLnNSpn
         nLNjfSCmbRtogx3ra9YFeLUXDYQ0QWSViApbYKV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 539/545] kvm: x86/pmu: Fix the compare function used by the pmu event filter
Date:   Fri, 19 Aug 2022 17:45:09 +0200
Message-Id: <20220819153853.713095678@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

commit 4ac19ead0dfbabd8e0bfc731f507cfb0b95d6c99 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -170,9 +170,12 @@ static bool pmc_resume_counter(struct kv
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


