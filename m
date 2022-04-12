Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E98E4FD968
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356118AbiDLHe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351575AbiDLH2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283C84EF6E;
        Tue, 12 Apr 2022 00:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F14B81B57;
        Tue, 12 Apr 2022 07:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96246C385A1;
        Tue, 12 Apr 2022 07:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747281;
        bh=0N2yIwdSXee9F6hKtUsnEzk1Wpq6MQKPHa6BD8iYw5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaQP3jMSNrpHjWB4YIevRhsfrc74Hy4xzCyh+MpIoqHl9uj+GRfJghFHgJKL6kRS6
         x0h57lW8a5Xa9jCZf5NVP5i8aZuSqG/rlY3iNZyBGuehD5x9Yl4KFfN1YDTxhq2jjH
         KK4+8Cd3eBsa8+TjOSDv5iBNfBK+E8vLySqBMAWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Peter Gonda <pgonda@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 007/343] KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()
Date:   Tue, 12 Apr 2022 08:27:05 +0200
Message-Id: <20220412062951.315041793@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Peter Gonda <pgonda@google.com>

[ Upstream commit 4a9e7b9ea252842bc8b14d495706ac6317fafd5d ]

Include kvm_cache_regs.h to pick up the definition of is_guest_mode(),
which is referenced by nested_svm_virtualize_tpr() in svm.h. Remove
include from svm_onhpyerv.c which was done only because of lack of
include in svm.h.

Fixes: 883b0a91f41ab ("KVM: SVM: Move Nested SVM Implementation to nested.c")
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Gonda <pgonda@google.com>
Message-Id: <20220304161032.2270688-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.h          | 2 ++
 arch/x86/kvm/svm/svm_onhyperv.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fa98d6844728..86bcfed6599e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -22,6 +22,8 @@
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
+#include "kvm_cache_regs.h"
+
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 #define	IOPM_SIZE PAGE_SIZE * 3
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 98aa981c04ec..8cdc62c74a96 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"
 
 #include <asm/mshyperv.h>
 
-- 
2.35.1



