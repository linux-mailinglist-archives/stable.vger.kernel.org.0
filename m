Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91F654882E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352512AbiFMLQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352769AbiFMLOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:14:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABCF369FD;
        Mon, 13 Jun 2022 03:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45FC7B80EA3;
        Mon, 13 Jun 2022 10:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997D6C34114;
        Mon, 13 Jun 2022 10:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116613;
        bh=SPVE0E2YJ48XYj0xRu3cSmgM4bWdPP+ZLndDgMbsIJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fxbwhi9dXGwNHL4S6BUrEUvTAJaTl+AaMOW+TtEKWvA14BP+FdPPgtFH/UqzRbw4I
         vG04az2CcYrENeJW48YCZF1CDAAvRpH72HvhXzFv/f/iz3NwZIYx73/3dEVkoYnn/4
         4hEKB+HIXUBVN7klFr77Fz880QlFw+WijQ723ZlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/411] x86/mm: Cleanup the control_va_addr_alignment() __setup handler
Date:   Mon, 13 Jun 2022 12:06:35 +0200
Message-Id: <20220613094932.332538524@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1ef64b1e89e6d4018da46e08ffc32779a31160c7 ]

Clean up control_va_addr_alignment():

a. Make '=' required instead of optional (as documented).
b. Print a warning if an invalid option value is used.
c. Return 1 from the __setup handler when an invalid option value is
   used. This prevents the kernel from polluting init's (limited)
   environment space with the entire string.

Fixes: dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing penalties on AMD family 15h")
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Link: https://lore.kernel.org/r/20220315001045.7680-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sys_x86_64.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index f7476ce23b6e..42e31358a9d3 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -70,9 +70,6 @@ static int __init control_va_addr_alignment(char *str)
 	if (*str == 0)
 		return 1;
 
-	if (*str == '=')
-		str++;
-
 	if (!strcmp(str, "32"))
 		va_align.flags = ALIGN_VA_32;
 	else if (!strcmp(str, "64"))
@@ -82,11 +79,11 @@ static int __init control_va_addr_alignment(char *str)
 	else if (!strcmp(str, "on"))
 		va_align.flags = ALIGN_VA_32 | ALIGN_VA_64;
 	else
-		return 0;
+		pr_warn("invalid option value: 'align_va_addr=%s'\n", str);
 
 	return 1;
 }
-__setup("align_va_addr", control_va_addr_alignment);
+__setup("align_va_addr=", control_va_addr_alignment);
 
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
-- 
2.35.1



