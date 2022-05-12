Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA3525762
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 23:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358954AbiELVv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 17:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358948AbiELVvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 17:51:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1782220E8;
        Thu, 12 May 2022 14:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652392271; x=1683928271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=64md03mIL4rLyNEj2DrQ+9Fy0MfvYA/Gx8/Lj+t6g9Q=;
  b=TH4He5JZDgtRF2HyyTA07iiRFeYyeYUh4/X4jwGnSBgaWW4NkCuqcmGp
   8x6+wEzFOC8JenD2T44VNKnSUn0yelmNPsB/ePiyF3rlq1r41Jub5ch6n
   OBtNaDjpDtuXbVpyjqh0lwV6LDVOpkiGSP5AVehHGHtARfTvCxVdfp9fO
   ltf0bcmmf6PDrlhsohE6MdVm5nMQODkr/eP0wqPWmleGjFUaJ525Vm+NP
   rRLhQWFUcD5kiW2ojZm47u0BiwE6P8Ivyb3EZef5Rj1gtdvkQrIK5V8cC
   9lZgPnP4dhT1DteEU8Yke2shgKNMLEfgGF1/IKgszxDLCHBuGR3zov7iD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="267736145"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="267736145"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:51:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="553955568"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:51:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     haitao.huang@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V3 2/5] x86/sgx: Mark PCMD page as dirty when modifying contents
Date:   Thu, 12 May 2022 14:50:58 -0700
Message-Id: <00cd2ac480db01058d112e347b32599c1a806bc4.1652389823.git.reinette.chatre@intel.com>
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

Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
after faulting the enclave page") expanded __sgx_encl_eldu()
to clear an enclave page's PCMD (Paging Crypto MetaData)
from the PCMD page in the backing store after the enclave
page is restored to the enclave.

Since the PCMD page in the backing store is modified the page
should be marked as dirty to ensure the modified data is retained.

Cc: stable@vger.kernel.org
Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- Set page as dirty after receiving data, not before. (Dave)
- Add Jarkko's Reviewed-by tag.
- Add Haitao's Tested-by tag.

Changes since RFC v1:
- Do not set dirty bit on enclave page since it is not being
  written to and always will be discarded.  (Dave)

 arch/x86/kernel/cpu/sgx/encl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 398695a20605..5104a428b72c 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -84,6 +84,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	}
 
 	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
+	set_page_dirty(b.pcmd);
 
 	/*
 	 * The area for the PCMD in the page was zeroed above.  Check if the
-- 
2.25.1

