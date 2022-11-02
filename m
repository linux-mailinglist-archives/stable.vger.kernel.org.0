Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084B1615828
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiKBCqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiKBCqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C768020F7B
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7244DB82073
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C417C433C1;
        Wed,  2 Nov 2022 02:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357176;
        bh=e+GIMqHRV/aeDZ8etUA+qQFFEiRSYaRx49n5SwYQp/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDrSu4yfXR/ne2G6De1T7H8ROWPHU3T7s4/pXC1DrWFOSxf/SCwyfp2UrFj04ZkQu
         yOWaR/iaHhnpNHp6xyOBC4fWEzA8s67SvBBedk1UBar17UtoQNSD9Z7XP0J4J/sGT8
         8uY6ohpmsNPiDG/wHfK/PhRd6tSh+6sfK4WOgQEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
        Pavel Kozlov <pavel.kozlov@synopsys.com>,
        Vineet Gupta <vgupta@kernel.org>
Subject: [PATCH 6.0 097/240] ARC: mm: fix leakage of memory allocated for PTE
Date:   Wed,  2 Nov 2022 03:31:12 +0100
Message-Id: <20221102022113.587705818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Kozlov <pavel.kozlov@synopsys.com>

commit 4fd9df10cb7a9289fbd22d669f9f98164d95a1ce upstream.

Since commit d9820ff ("ARC: mm: switch pgtable_t back to struct page *")
a memory leakage problem occurs. Memory allocated for page table entries
not released during process termination. This issue can be reproduced by
a small program that allocates a large amount of memory. After several
runs, you'll see that the amount of free memory has reduced and will
continue to reduce after each run. All ARC CPUs are effected by this
issue. The issue was introduced since the kernel stable release v5.15-rc1.

As described in commit d9820ff after switch pgtable_t back to struct
page *, a pointer to "struct page" and appropriate functions are used to
allocate and free a memory page for PTEs, but the pmd_pgtable macro hasn't
changed and returns the direct virtual address from the PMD (PGD) entry.
Than this address used as a parameter in the __pte_free() and as a result
this function couldn't release memory page allocated for PTEs.

Fix this issue by changing the pmd_pgtable macro and returning pointer to
struct page.

Fixes: d9820ff76f95 ("ARC: mm: switch pgtable_t back to struct page *")
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Pavel Kozlov <pavel.kozlov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/asm/pgtable-levels.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/include/asm/pgtable-levels.h
+++ b/arch/arc/include/asm/pgtable-levels.h
@@ -161,7 +161,7 @@
 #define pmd_pfn(pmd)		((pmd_val(pmd) & PAGE_MASK) >> PAGE_SHIFT)
 #define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
 #define set_pmd(pmdp, pmd)	(*(pmdp) = pmd)
-#define pmd_pgtable(pmd)	((pgtable_t) pmd_page_vaddr(pmd))
+#define pmd_pgtable(pmd)	((pgtable_t) pmd_page(pmd))
 
 /*
  * 4th level paging: pte


