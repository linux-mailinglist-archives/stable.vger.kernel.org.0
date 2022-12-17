Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A90B64FA6D
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiLQPf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiLQPfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:35:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EEA1DF35;
        Sat, 17 Dec 2022 07:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C650BB80315;
        Sat, 17 Dec 2022 15:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A03C433EF;
        Sat, 17 Dec 2022 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290978;
        bh=kyveXFP5qbO6PAPUg8lJQpPZzQRiNpZG7BF/hRQ2LT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilZJIu7yyrVQTJ0mYpSHUvbFrF8+89KZyzjAticDmYKQFwY5nTMlvR36PAksGBUvH
         VEPX24QO5f0n/atDXlSs5fGihZyt0IISllC0wmNul3scXRW4nxrjKXAWySczaSzJVJ
         4Agy+AHro3schTx0rhMx7P5KMrNrNOMtqrkIKvt3JnhT/JQZ6Rq/IzhTrQRZwNo+Oo
         QX+e+dGEfsturitQXUR6I45rWpv9sJTXiqDbm/z/p16lSfNtQG9UYDZjOhv7wiQxzw
         pGvHMfKCOyurdUaJx6aBtPohrbsidJGKsyfvkadtuzp/u3tATtnXVwaHjoHkcVsZa9
         WUDQjeJ5p0O3g==
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
Subject: [PATCH AUTOSEL 5.10 5/9] proc/vmcore: fix potential memory leak in vmcore_init()
Date:   Sat, 17 Dec 2022 10:29:22 -0500
Message-Id: <20221217152927.99012-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152927.99012-1-sashal@kernel.org>
References: <20221217152927.99012-1-sashal@kernel.org>
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
index 0e4278d4a769..484fa0c029e1 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1553,6 +1553,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
+		elfcorehdr_free(elfcorehdr_addr);
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
-- 
2.35.1

