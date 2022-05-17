Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3434852AA4E
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352024AbiEQSN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352090AbiEQSMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:12:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90133F883;
        Tue, 17 May 2022 11:12:04 -0700 (PDT)
Date:   Tue, 17 May 2022 18:12:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652811123;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BXI8z8bcDcRqqUjaLQmbtMzYJPa/NdLvRj4SrxwHIIs=;
        b=OZ3B96nVMavYX+QLN7TOmgNdKMqRmukdrOZ2kpPxnUqCMoky4CGZd2dVMW8rCT9tm9gfeO
        1coLTMoPx8nKe54dHLCJnKXJaV7/hMOGH5dzXqPfmPXNTSiv463KHx3Lz4QdM+16SO6VwM
        kFW+ZAm3RsG2im/vPNmwNd6lNGaUNPOA+LfFmhz9DkisQJg3n9ccZTR1pwrlCkD2kLjXAo
        V/WhQxTu+HYCAe2foyXvqgAhHavc6uYBuMzJe/3vVuozYllG+koyVUk2uNv+ld0F9EWbtb
        NTTjVYXk4cqxqbDC+Z2CzdY8Slwrdolee3Wm3p8cI6xVmJXURGdGbZLWfn6DNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652811123;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BXI8z8bcDcRqqUjaLQmbtMzYJPa/NdLvRj4SrxwHIIs=;
        b=QoBnHZSmniXk15eevK5NM5zMgMGQXCfT/4N+7puPFJG8EYxcZTHW+6UeCIdTiT6uxiSaWa
        hZbVpwyGFBIlKKCg==
From:   "tip-bot2 for Reinette Chatre" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/sgx] x86/sgx: Mark PCMD page as dirty when modifying contents
Cc:     stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C00cd2ac480db01058d112e347b32599c1a806bc4=2E16523?=
 =?utf-8?q?89823=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3C00cd2ac480db01058d112e347b32599c1a806bc4=2E165238?=
 =?utf-8?q?9823=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <165281112223.4207.18287723903860533713.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/sgx branch of tip:

Commit-ID:     2154e1c11b7080aa19f47160bd26b6f39bbd7824
Gitweb:        https://git.kernel.org/tip/2154e1c11b7080aa19f47160bd26b6f39bbd7824
Author:        Reinette Chatre <reinette.chatre@intel.com>
AuthorDate:    Thu, 12 May 2022 14:50:58 -07:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Mon, 16 May 2022 15:17:14 -07:00

x86/sgx: Mark PCMD page as dirty when modifying contents

Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
after faulting the enclave page") expanded __sgx_encl_eldu()
to clear an enclave page's PCMD (Paging Crypto MetaData)
from the PCMD page in the backing store after the enclave
page is restored to the enclave.

Since the PCMD page in the backing store is modified the page
should be marked as dirty to ensure the modified data is retained.

Cc: stable@vger.kernel.org
Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lkml.kernel.org/r/00cd2ac480db01058d112e347b32599c1a806bc4.1652389823.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/sgx/encl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 398695a..5104a42 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -84,6 +84,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	}
 
 	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
+	set_page_dirty(b.pcmd);
 
 	/*
 	 * The area for the PCMD in the page was zeroed above.  Check if the
