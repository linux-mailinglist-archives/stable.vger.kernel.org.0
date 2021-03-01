Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83526328CF0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhCATCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:02:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240650AbhCASzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:55:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 137F0650BC;
        Mon,  1 Mar 2021 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620428;
        bh=vGT1dut4182hzwAmDAdxHyyVSh1AEaQMcfPe0AEkcX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1Hhd9XaWI6zK9NhnMrNQHZFg7/JXtxpj/5ayP36EfPeiT/C+cMZVFzORujbuHDbV
         z/acs9iCfqrWXTwPZExB6SjoT/MC8kopq5qKGNQbFo9ccjoXQquSKnMaYyk9Fs2tS8
         UgOkecHSUcxRwnPm9NR6lfeB8T45t2hwYnDQxbok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Borislav Petkov <bp@suse.de>,
        Darren Kenny <darren.kenny@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 150/775] x86/sgx: Fix the return type of sgx_init()
Date:   Mon,  1 Mar 2021 17:05:18 +0100
Message-Id: <20210301161209.062411528@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 31bf92881714fe9962d43d097b5114a9b4ad0a12 ]

device_initcall() expects a function of type initcall_t, which returns
an integer. Change the signature of sgx_init() to match.

Fixes: e7e0545299d8c ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/20210113232311.277302-1-samitolvanen@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c519fc5f69480..8df81a3ed9457 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -700,25 +700,27 @@ static bool __init sgx_page_cache_init(void)
 	return true;
 }
 
-static void __init sgx_init(void)
+static int __init sgx_init(void)
 {
 	int ret;
 	int i;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SGX))
-		return;
+		return -ENODEV;
 
 	if (!sgx_page_cache_init())
-		return;
+		return -ENOMEM;
 
-	if (!sgx_page_reclaimer_init())
+	if (!sgx_page_reclaimer_init()) {
+		ret = -ENOMEM;
 		goto err_page_cache;
+	}
 
 	ret = sgx_drv_init();
 	if (ret)
 		goto err_kthread;
 
-	return;
+	return 0;
 
 err_kthread:
 	kthread_stop(ksgxd_tsk);
@@ -728,6 +730,8 @@ err_page_cache:
 		vfree(sgx_epc_sections[i].pages);
 		memunmap(sgx_epc_sections[i].virt_addr);
 	}
+
+	return ret;
 }
 
 device_initcall(sgx_init);
-- 
2.27.0



