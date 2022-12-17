Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0995E64FABF
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiLQPko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiLQPjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:39:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5485FD28;
        Sat, 17 Dec 2022 07:30:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B7E360C16;
        Sat, 17 Dec 2022 15:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04457C433D2;
        Sat, 17 Dec 2022 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671291043;
        bh=y+kmgpEiykvKKnDemjnarN7AvnnMPA0u9a6lbU9fUVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZfasNxAH19clQwmspfHc0RQX4Gqbc2ttYaigdT/56euZBSBhyK6Vxy29uj0FLIBZ
         s6yTriSFIZUShexsSHAJRncoHDwMuHjIC08eSJzBb+ShbLcos6gGqN3H41vk32FsPU
         cNRQIgp6C/AIpLPKNylR3AaAoaUpMd5M+Tt9luTYTxUA+0IEd1Uxq2BvzlAl4ktS+D
         9HCpTf/1Sc2WGj8MpcU4xHLhLOdUkH5hz+MPOSHF3ctcDehtJu4X9awsKqaOK4z7Hl
         3+bcdcYDLRQXB7SnhoFIJ1fvlyN2d+a9vzy2A6CQs+1WvueqCl2K76BD/2gGUja9Fb
         9dhYkHwXIfNaw==
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
Subject: [PATCH AUTOSEL 4.14 5/8] proc/vmcore: fix potential memory leak in vmcore_init()
Date:   Sat, 17 Dec 2022 10:30:28 -0500
Message-Id: <20221217153033.99394-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217153033.99394-1-sashal@kernel.org>
References: <20221217153033.99394-1-sashal@kernel.org>
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
index 0bfd71bec7f2..2ed309191d91 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1177,6 +1177,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
+		elfcorehdr_free(elfcorehdr_addr);
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
-- 
2.35.1

