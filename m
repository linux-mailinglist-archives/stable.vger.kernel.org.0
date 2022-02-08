Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981884ACFB2
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 04:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiBHDV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 22:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiBHDVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 22:21:25 -0500
Received: from spam.unicloud.com (mx.gosinoic.com [220.194.70.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6252AC043188;
        Mon,  7 Feb 2022 19:21:23 -0800 (PST)
Received: from eage.unicloud.com ([220.194.70.35])
        by spam.unicloud.com with ESMTP id 2183Kac4021080;
        Tue, 8 Feb 2022 11:20:36 +0800 (GMT-8)
        (envelope-from luofei@unicloud.com)
Received: from localhost.localdomain (10.10.1.7) by zgys-ex-mb09.Unicloud.com
 (10.10.0.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2375.17; Tue, 8
 Feb 2022 11:20:35 +0800
From:   luofei <luofei@unicloud.com>
To:     <stable@vger.kernel.org>, <tony.luck@intel.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>
CC:     <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        luofei <luofei@unicloud.com>
Subject: [PATCH] x86/mm, mm/hwpoison: Fix the unmap kernel 1:1 pages check condition
Date:   Mon, 7 Feb 2022 22:20:28 -0500
Message-ID: <20220208032028.852302-1-luofei@unicloud.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.10.1.7]
X-ClientProxiedBy: zgys-ex-mb10.Unicloud.com (10.10.0.6) To
 zgys-ex-mb09.Unicloud.com (10.10.0.24)
X-DNSRBL: 
X-MAIL: spam.unicloud.com 2183Kac4021080
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fd0e786d9d09024f67bd71ec094b110237dc3840 ]

This commit solves the problem of unmap kernel 1:1 pages
unconditionally, it appears in Linus's tree 4.16 and later
versions, and is backported to 4.14.x and 4.15.x stable branches.

But the backported patch has its logic reversed when calling
memory_failure() to determine whether it needs to unmap the
kernel page. Only when memory_failure() returns successfully,
the kernel page can be unmapped.

Signed-off-by: luofei <luofei@unicloud.com>
Cc: stable@vger.kernel.org #v4.14.x
Cc: stable@vger.kernel.org #v4.15.x
---
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 95c09db1bba2..d8399a689165 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -589,7 +589,7 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
 
 	if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
 		pfn = mce->addr >> PAGE_SHIFT;
-		if (memory_failure(pfn, MCE_VECTOR, 0))
+		if (!memory_failure(pfn, MCE_VECTOR, 0))
 			mce_unmap_kpfn(pfn);
 	}
 
-- 
2.27.0

