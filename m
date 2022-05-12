Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31E52575A
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 23:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358909AbiELVvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 17:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358953AbiELVvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 17:51:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA2A25281;
        Thu, 12 May 2022 14:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652392273; x=1683928273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WGtjIs84L/V8d5pSZdC22spiQhlH/l6Fco984mpyl0g=;
  b=MzdV8wEBgu0asom5NFnpQpj96r36cEmA+28twfgelSeKUGmEtDG2WAD7
   QaL9Ej91pLM+th09YHsaZxtRPRq6xFpSTA7KJOYeDufFrcD+oh8sOSrfX
   k7A8u0BcA2j3jRQabSgenJ2gARBt6ILQweB611BU0vkG0C0m3lfq2hc7z
   pXZrzBRXt/8WNbfUH1sENVe8TNUcW9Wd0OKtLlZBaNMQzZDYQLmIYCoMG
   Hp4+sAxhprKM32yelzKi6rsNs/LhC0ojlnx1lMA+gTA0wvXv48RYKk3rU
   cTXgdpUD/km4Vgut33+tvjv+EGOf59Pg2a1kqtFAHwQ0LcnPCXGt+sbHB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="267736152"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="267736152"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:51:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="553955576"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:51:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     haitao.huang@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V3 5/5] x86/sgx: Ensure no data in PCMD page after truncate
Date:   Thu, 12 May 2022 14:51:01 -0700
Message-Id: <6495120fed43fafc1496d09dd23df922b9a32709.1652389823.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1652389823.git.reinette.chatre@intel.com>
References: <cover.1652389823.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A PCMD (Paging Crypto MetaData) page contains the PCMD
structures of enclave pages that have been encrypted and
moved to the shmem backing store. When all enclave pages
sharing a PCMD page are loaded in the enclave, there is no
need for the PCMD page and it can be truncated from the
backing store.

A few issues appeared around the truncation of PCMD pages. The
known issues have been addressed but the PCMD handling code could
be made more robust by loudly complaining if any new issue appears
in this area.

Add a check that will complain with a warning if the PCMD page is not
actually empty after it has been truncated. There should never be data
in the PCMD page at this point since it is was just checked to be empty
and truncated with enclave mutex held and is updated with the
enclave mutex held.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- Change WARN_ON_ONCE() to pr_warn(). (Jarkko).
- Add Haitao's Tested-by tag.

Changes since RFC v1:
- New patch.

 arch/x86/kernel/cpu/sgx/encl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 243f3bd78145..3c24e6124d95 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -187,12 +187,20 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
+	get_page(b.pcmd);
 	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page))
+	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page)) {
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+		pcmd_page = kmap_atomic(b.pcmd);
+		if (memchr_inv(pcmd_page, 0, PAGE_SIZE))
+			pr_warn("PCMD page not empty after truncate.\n");
+		kunmap_atomic(pcmd_page);
+	}
+
+	put_page(b.pcmd);
 
 	return ret;
 }
-- 
2.25.1

