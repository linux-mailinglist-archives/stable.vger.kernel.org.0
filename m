Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA6650F7DB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346535AbiDZJLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346282AbiDZJH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C608CE4BC;
        Tue, 26 Apr 2022 01:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB2560C42;
        Tue, 26 Apr 2022 08:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF8FC385A4;
        Tue, 26 Apr 2022 08:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962924;
        bh=C7K6+dIhO4lVsvHYxez6CLHJhbjfmzvpry9EP/SdI58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzeRNfM2nQMjvHFOqOfDyUvLdHo2eUd/C0zXeIoQXXknao/vVJxWWbZExMyHoHh7U
         65JsoF14vuqYZlnSSLN+2WbLRpwX0QCsxT7rYpFpOMRSLBGCQMZg8kdjs2nkc1xcXi
         fjwgKIPcIdarGZ2+xSDMRMFagpnFatV0ZJW71zr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vger.kerel.org,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 133/146] KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT CPUs
Date:   Tue, 26 Apr 2022 10:22:08 +0200
Message-Id: <20220426081753.797805653@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingwei Zhang <mizhang@google.com>

commit d45829b351ee6ec5f54dd55e6aca1f44fe239fe6 upstream.

Use clflush_cache_range() to flush the confidential memory when
SME_COHERENT is supported in AMD CPU. Cache flush is still needed since
SME_COHERENT only support cache invalidation at CPU side. All confidential
cache lines are still incoherent with DMA devices.

Cc: stable@vger.kerel.org

Fixes: add5e2f04541 ("KVM: SVM: Add support for the SEV-ES VMSA")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Message-Id: <20220421031407.2516575-3-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2217,11 +2217,14 @@ static void sev_flush_encrypted_page(str
 	unsigned long addr = (unsigned long)va;
 
 	/*
-	 * If hardware enforced cache coherency for encrypted mappings of the
-	 * same physical page is supported, nothing to do.
+	 * If CPU enforced cache coherency for encrypted mappings of the
+	 * same physical page is supported, use CLFLUSHOPT instead. NOTE: cache
+	 * flush is still needed in order to work properly with DMA devices.
 	 */
-	if (boot_cpu_has(X86_FEATURE_SME_COHERENT))
+	if (boot_cpu_has(X86_FEATURE_SME_COHERENT)) {
+		clflush_cache_range(va, PAGE_SIZE);
 		return;
+	}
 
 	/*
 	 * VM Page Flush takes a host virtual address and a guest ASID.  Fall


