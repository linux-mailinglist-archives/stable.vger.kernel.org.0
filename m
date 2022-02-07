Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD64AB62C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiBGICj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349742AbiBGHyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 02:54:21 -0500
X-Greylist: delayed 218 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 23:54:19 PST
Received: from spam.unicloud.com (smgmail.unigroup.com.cn [220.194.70.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8C2C043181
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 23:54:18 -0800 (PST)
Received: from eage.unicloud.com ([220.194.70.35])
        by spam.unicloud.com with ESMTP id 2177qtS2055331;
        Mon, 7 Feb 2022 15:52:55 +0800 (GMT-8)
        (envelope-from luofei@unicloud.com)
Received: from localhost.localdomain (10.10.1.7) by zgys-ex-mb09.Unicloud.com
 (10.10.0.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2375.17; Mon, 7
 Feb 2022 15:52:54 +0800
From:   luofei <luofei@unicloud.com>
To:     <stable@vger.kernel.org>, <tony.luck@intel.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>
CC:     <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        luofei <luofei@unicloud.com>
Subject: [PATCH] x86/mm, mm/hwpoison: fix unmap kernel 1:1 pages
Date:   Mon, 7 Feb 2022 02:52:42 -0500
Message-ID: <20220207075242.830685-1-luofei@unicloud.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.10.1.7]
X-ClientProxiedBy: zgys-ex-mb10.Unicloud.com (10.10.0.6) To
 zgys-ex-mb09.Unicloud.com (10.10.0.24)
X-DNSRBL: 
X-MAIL: spam.unicloud.com 2177qtS2055331
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only unmap the page when the memory error is properly handled
by calling memory_failure(), not the other way around.

Fixes: 26f8c38bb466("x86/mm, mm/hwpoison: Don't unconditionally unmap kernel 1:1 pages")

Signed-off-by: luofei <luofei@unicloud.com>
Cc: stable@vger.kernel.org #v4.14
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

