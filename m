Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C6579B88
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbiGSM2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240194AbiGSM2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:28:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4878764E29;
        Tue, 19 Jul 2022 05:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E7CFB81B31;
        Tue, 19 Jul 2022 12:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC51C36AE3;
        Tue, 19 Jul 2022 12:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232631;
        bh=d+71EalB50Uc0i6nLQFzHJCfV5jCOiAfGvQG3wu8oN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kusrt80Obfnxv8/LPq+cWVpnMzSOm4lqshArtUtofocBDPJvtzGy8rOCSmlWM0N8g
         Ly6/lW3ClGPHvNRSM82TdN+DWMzmY+kO8sm2i3EqJaKXpwFlj2NoG2oFlx2/d7Vdfk
         ZGneCzmslrrJxgj0TG6Ko0HM6hwS2ioAzBRLGCkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Gowans <jgowans@amazon.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "=?UTF-8?q?Jan=20H . =20Sch=C3=B6nherr?=" <jschoenh@amazon.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 011/167] mm: split huge PUD on wp_huge_pud fallback
Date:   Tue, 19 Jul 2022 13:52:23 +0200
Message-Id: <20220719114657.774064569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gowans, James <jgowans@amazon.com>

commit 14c99d65941538aa33edd8dc7b1bbbb593c324a2 upstream.

Currently the implementation will split the PUD when a fallback is taken
inside the create_huge_pud function.  This isn't where it should be done:
the splitting should be done in wp_huge_pud, just like it's done for PMDs.
Reason being that if a callback is taken during create, there is no PUD
yet so nothing to split, whereas if a fallback is taken when encountering
a write protection fault there is something to split.

It looks like this was the original intention with the commit where the
splitting was introduced, but somehow it got moved to the wrong place
between v1 and v2 of the patch series.  Rebase mistake perhaps.

Link: https://lkml.kernel.org/r/6f48d622eb8bce1ae5dd75327b0b73894a2ec407.camel@amazon.com
Fixes: 327e9fd48972 ("mm: Split huge pages on write-notify or COW")
Signed-off-by: James Gowans <jgowans@amazon.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4491,6 +4491,19 @@ static vm_fault_t create_huge_pud(struct
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vmf->vma))
+		return VM_FAULT_FALLBACK;
+	if (vmf->vma->vm_ops->huge_fault)
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	return VM_FAULT_FALLBACK;
+}
+
+static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	/* No support for anonymous transparent PUD pages yet */
+	if (vma_is_anonymous(vmf->vma))
 		goto split;
 	if (vmf->vma->vm_ops->huge_fault) {
 		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
@@ -4501,19 +4514,7 @@ static vm_fault_t create_huge_pud(struct
 split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
 	__split_huge_pud(vmf->vma, vmf->pud, vmf->address);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-	return VM_FAULT_FALLBACK;
-}
-
-static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	/* No support for anonymous transparent PUD pages yet */
-	if (vma_is_anonymous(vmf->vma))
-		return VM_FAULT_FALLBACK;
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 	return VM_FAULT_FALLBACK;
 }
 


