Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D89594B6B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243802AbiHPARi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348939AbiHPAOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:14:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FCDA1A6F;
        Mon, 15 Aug 2022 13:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 901FD60EE9;
        Mon, 15 Aug 2022 20:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97752C433D6;
        Mon, 15 Aug 2022 20:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595430;
        bh=sUYHBipSOEdGPK0bzVoiieG+BjNTS4qmLJDmSZz66vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ij9VvMN7+g2eNQd/1Grv6fJqMgVqVRntMZPV8A3moUWXvR4Us05pI8zyGu6QXQNXK
         WTEAOsLs0puuVoRtolVu3zKQLabQdknogRoriftB7NcTgbFqMxRTeQ6ROg98O/kDT4
         ROzlF51yrCr3fNHSsyW/gve/n84ErqQriGlvKCpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0729/1157] KVM: Dont set Accessed/Dirty bits for ZERO_PAGE
Date:   Mon, 15 Aug 2022 20:01:25 +0200
Message-Id: <20220815180508.628828885@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a1040b0d42acf69bb4f6dbdc54c2dcd78eea1de5 ]

Don't set Accessed/Dirty bits for a struct page with PG_reserved set,
i.e. don't set A/D bits for the ZERO_PAGE.  The ZERO_PAGE (or pages
depending on the architecture) should obviously never be written, and
similarly there's no point in marking it accessed as the page will never
be swapped out or reclaimed.  The comment in page-flags.h is quite clear
that PG_reserved pages should be managed only by their owner, and
strictly following that mandate also simplifies KVM's logic.

Fixes: 7df003c85218 ("KVM: fix overflow of zero page refcount with ksm running")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220429010416.2788472-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 28126ee221b5..98246f3dea87 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2853,16 +2853,28 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
+static bool kvm_is_ad_tracked_pfn(kvm_pfn_t pfn)
+{
+	if (!pfn_valid(pfn))
+		return false;
+
+	/*
+	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
+	 * touched (e.g. set dirty) except by its owner".
+	 */
+	return !PageReserved(pfn_to_page(pfn));
+}
+
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (kvm_is_ad_tracked_pfn(pfn))
 		SetPageDirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (kvm_is_ad_tracked_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
-- 
2.35.1



