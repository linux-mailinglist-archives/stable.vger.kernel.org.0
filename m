Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331AF64FA67
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiLQPee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiLQPd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:33:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0115316584;
        Sat, 17 Dec 2022 07:29:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC150B801C0;
        Sat, 17 Dec 2022 15:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1794C433F0;
        Sat, 17 Dec 2022 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290956;
        bh=HogrSsBYy7kIgZO34up4ieXnOK9WeL0SfkO5lVszAss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUijpDPmEgHvX9wLHOeaAepemYJTm25dcDHGY6SlroCqQPzvTO39420CKY551CCTZ
         xTtH8klEr0viVZRFNuZP1sOeKHUT7nAUTlc//mxFz3/7LEJPApe9bC9UO9Y1go4DMP
         o0z+7+S/OnHgNyigE6t1cT5ISTovLrtr/TrB9eoK+LnOyTO1sTbdiYwopiHvnaA34a
         5BgVMnJRbtoH/afZFDZP9e411GzD60R1yQKohiLrPs5C+AdE4UhldEtaeRJSDgrAd3
         8g680q6SUiVLpHh+6BrjgEx/xp99UESsnEGhHAPkSFAFtIBg/bczFLRFK1aOqU3mbS
         M3I5H9abE35pQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Baoquan He <bhe@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Lifu <chenlifu@huawei.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Li Chen <lchen@ambarella.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Petr Mladek <pmladek@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/10] proc/vmcore: fix potential memory leak in vmcore_init()
Date:   Sat, 17 Dec 2022 10:28:56 -0500
Message-Id: <20221217152902.98870-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152902.98870-1-sashal@kernel.org>
References: <20221217152902.98870-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 12b9d301ff73122aebd78548fa4c04ca69ed78fe ]

Patch series "Some minor cleanup patches resent".

The first three patches trivial clean up patches.

And for the patch "kexec: replace crash_mem_range with range", I got a
ibm-p9wr ppc64le system to test, it works well.

This patch (of 4):

elfcorehdr_alloc() allocates a memory chunk for elfcorehdr_addr with
kzalloc().  If is_vmcore_usable() returns false, elfcorehdr_addr is a
predefined value.  If parse_crash_elf_headers() gets some error and
returns a negetive value, the elfcorehdr_addr should be released with
elfcorehdr_free().

Fix it by calling elfcorehdr_free() when parse_crash_elf_headers() fails.

Link: https://lkml.kernel.org/r/20220929042936.22012-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20220929042936.22012-2-bhe@redhat.com
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Lifu <chenlifu@huawei.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Li Chen <lchen@ambarella.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/vmcore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index e5730986758f..d3286d8634d9 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1550,6 +1550,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
+		elfcorehdr_free(elfcorehdr_addr);
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
-- 
2.35.1

