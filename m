Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2653D4D81F0
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiCNL6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbiCNL6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2FB65DA;
        Mon, 14 Mar 2022 04:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C72260FF3;
        Mon, 14 Mar 2022 11:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69988C340EC;
        Mon, 14 Mar 2022 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259023;
        bh=boM+X7Jtz7xEMxABclzXsyS0I01CPMFAo2H06POull4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xziltt+wAcGFP9SuI8BN6fBf6kWHxitrlACPlZJ4rsrRoyTrTt0O3nCe87SIfFO5i
         u+BfgitpxZ10kyd0IYhyGp8RwL/59MzKZFrtW+p91plE9m953CE7pHsLOEv47Uxzj+
         QyHywmqwruCp80ed94T3x6GcbgkD20cRFtT7bvL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, patches@armlinux.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 29/43] ARM: Spectre-BHB: provide empty stub for non-config
Date:   Mon, 14 Mar 2022 12:53:40 +0100
Message-Id: <20220314112735.237801373@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 68453767131a5deec1e8f9ac92a9042f929e585d upstream.

When CONFIG_GENERIC_CPU_VULNERABILITIES is not set, references
to spectre_v2_update_state() cause a build error, so provide an
empty stub for that function when the Kconfig option is not set.

Fixes this build error:

  arm-linux-gnueabi-ld: arch/arm/mm/proc-v7-bugs.o: in function `cpu_v7_bugs_init':
  proc-v7-bugs.c:(.text+0x52): undefined reference to `spectre_v2_update_state'
  arm-linux-gnueabi-ld: proc-v7-bugs.c:(.text+0x82): undefined reference to `spectre_v2_update_state'

Fixes: b9baf5c8c5c3 ("ARM: Spectre-BHB workaround")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: patches@armlinux.org.uk
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/spectre.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/include/asm/spectre.h
+++ b/arch/arm/include/asm/spectre.h
@@ -25,7 +25,13 @@ enum {
 	SPECTRE_V2_METHOD_LOOP8 = BIT(__SPECTRE_V2_METHOD_LOOP8),
 };
 
+#ifdef CONFIG_GENERIC_CPU_VULNERABILITIES
 void spectre_v2_update_state(unsigned int state, unsigned int methods);
+#else
+static inline void spectre_v2_update_state(unsigned int state,
+					   unsigned int methods)
+{}
+#endif
 
 int spectre_bhb_update_vectors(unsigned int method);
 


