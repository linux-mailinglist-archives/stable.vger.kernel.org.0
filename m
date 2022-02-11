Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D308A4B1AF5
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 02:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346663AbiBKBIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 20:08:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239061AbiBKBIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 20:08:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAE9B3F;
        Thu, 10 Feb 2022 17:08:53 -0800 (PST)
Date:   Fri, 11 Feb 2022 01:08:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644541730;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJG2K6yK6beclfHEUgTRPm0L+hZjgYhcQ+rfNcW2yCA=;
        b=ABdioSNRvNJ1NwBmAJkgqVWQSYABc8LKhsFmzstsNIY/sVsAVoi34QylwpKWfqv66Lubf7
        1c2RhTfRDnJP+kqVip4b5SqnmCnE7JdlFEQjD46DvsAaKOglZpmj5s/hzkYS4FdE4qp5lp
        vojGVwya2/AUZogY09q0JVeM3SRDOabiT/JDiBesUSm2336ULfUsTTJaGp1ERFy1FEw780
        +uIo2VUk9PhgEKRV0nC3Myvjp892xRefrzLSIpXjOkUYRCv9AT6xv9xMUEEYufmE8JaMxy
        LwB9Zqv70UAspG/YAe79wgs4ZdM1FWPyTV0BXolnygeBA2HmCj09y9FzBuN6Uw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644541730;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJG2K6yK6beclfHEUgTRPm0L+hZjgYhcQ+rfNcW2yCA=;
        b=glroVRquyhDYs+oEDXrq27+SnCMwxRe1Kxjs1scQvc3aPDCzXSwSZU8LwHGunyV2uJJk5o
        Qbh8Oza/1zLNy4Dg==
From:   "tip-bot2 for Reinette Chatre" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sgx: Silence softlockup detection when
 releasing large enclaves
Cc:     stable@vger.kernel.org, Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Cced01cac1e75f900251b0a4ae1150aa8ebd295ec=2E16443?=
 =?utf-8?q?45232=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3Cced01cac1e75f900251b0a4ae1150aa8ebd295ec=2E164434?=
 =?utf-8?q?5232=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <164454172947.16921.6907341093129074331.tip-bot2@tip-bot2>
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

Commit-ID:     8795359e35bc33bf86b6d0765aa7f37431db3b9c
Gitweb:        https://git.kernel.org/tip/8795359e35bc33bf86b6d0765aa7f37431db3b9c
Author:        Reinette Chatre <reinette.chatre@intel.com>
AuthorDate:    Tue, 08 Feb 2022 10:48:07 -08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 10 Feb 2022 15:58:14 -08:00

x86/sgx: Silence softlockup detection when releasing large enclaves

Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
triggers the softlockup detector.

Actual SGX systems have 128GB of enclave memory or more.  The
"unclobbered_vdso_oversubscribed" selftest creates one enclave which
consumes all of the enclave memory on the system. Tearing down such a
large enclave takes around a minute, most of it in the loop where
the EREMOVE instruction is applied to each individual 4k enclave page.

Spending one minute in a loop triggers the softlockup detector.

Add a cond_resched() to give other tasks a chance to run and placate
the softlockup detector.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>  (kselftest as sanity check)
Link: https://lkml.kernel.org/r/ced01cac1e75f900251b0a4ae1150aa8ebd295ec.1644345232.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/sgx/encl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e..48afe96 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -410,6 +410,8 @@ void sgx_encl_release(struct kref *ref)
 		}
 
 		kfree(entry);
+		/* Invoke scheduler to prevent soft lockups. */
+		cond_resched();
 	}
 
 	xa_destroy(&encl->page_array);
