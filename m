Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2D6357C1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbiKWJpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbiKWJpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:45:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF4960EB5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94D6CB81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB9EC433D7;
        Wed, 23 Nov 2022 09:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196571;
        bh=aCKGMVKPakv7HyUJ3PwD7Rf3yORt3Ni753ZXzCAlG4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qht74sJR6rAD22wQ8mUo0m7NqaGwB90pjUZZVd6eb3xiAUPQC5IIN0m3NsbiK8U1Q
         HliQ1qXTYWQBr0J37DDjrKt+ghmRVbEBhfa5w5tCu0peTUwNCLlbKr++QMopQTauic
         Q9jdS04T4Dr0Dv0N9vrWm85HgrY8SGwZqVifyFEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 067/314] KVM: SVM: remove dead field from struct svm_cpu_data
Date:   Wed, 23 Nov 2022 09:48:32 +0100
Message-Id: <20221123084628.518538043@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 181d0fb0bb023e8996b1cf7970e3708d72442b0b ]

The "cpu" field of struct svm_cpu_data has been write-only since commit
4b656b120249 ("KVM: SVM: force new asid on vcpu migration", 2009-08-05).
Remove it.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e287bd005ad9 ("KVM: SVM: restore host save area from assembly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 1 -
 arch/x86/kvm/svm/svm.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 454746641a48..ecf4d8233e49 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -667,7 +667,6 @@ static int svm_cpu_init(int cpu)
 	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
 	if (!sd)
 		return ret;
-	sd->cpu = cpu;
 	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!sd->save_area)
 		goto free_cpu_data;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7ff1879e73c5..8a8894d948a0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -281,8 +281,6 @@ struct vcpu_svm {
 };
 
 struct svm_cpu_data {
-	int cpu;
-
 	u64 asid_generation;
 	u32 max_asid;
 	u32 next_asid;
-- 
2.35.1



