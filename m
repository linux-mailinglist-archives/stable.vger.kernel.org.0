Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5932AEA9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 03:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhCCAAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241819AbhCBCdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 21:33:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D9B64D9C;
        Tue,  2 Mar 2021 02:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614652389;
        bh=2/sTuEpFwd93bBqjR0EAjn1gZBYjn5jEVQYV6u7dFpA=;
        h=From:To:Cc:Subject:Date:From;
        b=rD1yibcbaSMszD1yM2dmQRNfJ4p5XqppStQyE7CxzroWtmN8S85IOT+fP6srcl+6x
         dWos1wnPmF9m0OF6eKaZiPV6sY8Q7vjSql7tNzhn5XF90+9oYQ3QahBnW4pEvY31Yi
         xlGsntppQDTmgfBXoa8Xr65I6PFwUq7TAdi61ST+7IzT5VxJT0aYA3I7JciaG3/2Ek
         7zyUyQWeexcpo6QP64YJJ4rvEPMKlWHJ2AL8drC2tEMyygMwr/JcW7bFuuLuiO8NwW
         BZpSSa6SHj2KAUv6EmyyPGRVlzvAVhICezyuQ/pVbzeFjgu8kcTk6PGuecugbutSj8
         +ZYNikt0cSZfQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Serge Ayoun <serge.ayoun@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Fix a resource leak in sgx_init()
Date:   Tue,  2 Mar 2021 04:32:42 +0200
Message-Id: <20210302023242.112285-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If sgx_page_cache_init() fails in the middle, a trivial return statement
causes unused memory and virtual address space reserved for the EPC
section, not freed. Fix this by using the same rollback, as when
sgx_page_reclaimer_init() fails.

Cc: stable@vger.kernel.org # 5.11
Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..52d070fb4c9a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -708,8 +708,10 @@ static int __init sgx_init(void)
 	if (!cpu_feature_enabled(X86_FEATURE_SGX))
 		return -ENODEV;
 
-	if (!sgx_page_cache_init())
-		return -ENOMEM;
+	if (!sgx_page_cache_init()) {
+		ret = -ENOMEM;
+		goto err_page_cache;
+	}
 
 	if (!sgx_page_reclaimer_init()) {
 		ret = -ENOMEM;
-- 
2.30.1

