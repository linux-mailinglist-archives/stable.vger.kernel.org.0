Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0335B3C0B
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 17:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiIIPdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 11:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiIIPdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 11:33:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078A42DAA8;
        Fri,  9 Sep 2022 08:32:45 -0700 (PDT)
Date:   Fri, 09 Sep 2022 15:31:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662737478;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8puwUi/3Qg2xUa9DdkAjRyjCefCro43pK6avKxOsik=;
        b=Tlgj+ITW4P6GBeHjLyqDzTGGrUxITX97hVHzZGnGPUc211H52Cz0Fl3wMBliduJhClLC9Z
        KC/Np7o5XPgH5qrqCxH3jNDOsoa6eeLOZxIzpwPRRCOwd4IFC/3dBkLKI4jzChVSe47lt9
        OvJ/J5ffufUbdzw2Sj3MyghFLd5RxG89iBT20qAfVe+fqp1zWjK5bCAWJiOg0bd5EPY0nk
        isOdvYPquauLWIxylIMSFRgQ2flzYRtKUroOWszwYUlrRdX38DgJ55iUC7uaZ4r16nAbQo
        o5DH7/7xyLv/XQDHcKQozGaVivaKNi6q/8n3NJyDNOvaCGu9MZ8RnlsgFd2Yyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662737478;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8puwUi/3Qg2xUa9DdkAjRyjCefCro43pK6avKxOsik=;
        b=8BQN1iTwvaKPP0IUHBX1GVmJrowPIIA0nrGRbKbaVbFqVONHyqrlwtJczy5gouRBAkQ6G7
        KjyPI8MiitjkZdBg==
From:   "tip-bot2 for Haitao Huang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sgx: Handle VA page allocation failure for EAUG on PF.
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220906000221.34286-3-jarkko@kernel.org>
References: <20220906000221.34286-3-jarkko@kernel.org>
MIME-Version: 1.0
Message-ID: <166273747726.401.7413581964147438392.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     81fa6fd13b5c43601fba8486f2385dbd7c1935e2
Gitweb:        https://git.kernel.org/tip/81fa6fd13b5c43601fba8486f2385dbd7c1935e2
Author:        Haitao Huang <haitao.huang@linux.intel.com>
AuthorDate:    Tue, 06 Sep 2022 03:02:21 +03:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 08 Sep 2022 13:28:31 -07:00

x86/sgx: Handle VA page allocation failure for EAUG on PF.

VM_FAULT_NOPAGE is expected behaviour for -EBUSY failure path, when
augmenting a page, as this means that the reclaimer thread has been
triggered, and the intention is just to round-trip in ring-3, and
retry with a new page fault.

Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220906000221.34286-3-jarkko@kernel.org
---
 arch/x86/kernel/cpu/sgx/encl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 24c1bb8..8bdeae2 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	}
 
 	va_page = sgx_encl_grow(encl, false);
-	if (IS_ERR(va_page))
+	if (IS_ERR(va_page)) {
+		if (PTR_ERR(va_page) == -EBUSY)
+			vmret = VM_FAULT_NOPAGE;
 		goto err_out_epc;
+	}
 
 	if (va_page)
 		list_add(&va_page->list, &encl->va_pages);
