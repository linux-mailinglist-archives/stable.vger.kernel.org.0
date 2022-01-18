Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A4491AE3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352466AbiARDAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345657AbiARCs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:48:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78ABC06175B;
        Mon, 17 Jan 2022 18:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D2CCB81255;
        Tue, 18 Jan 2022 02:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AC0C36AEB;
        Tue, 18 Jan 2022 02:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473592;
        bh=3nv0rTAvSjmrK3ODMmnkVpkb/3ZV6bPUkz/GTjh9ROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQU9m/JVgqk8lee2AVat5YX/ME4IZlybOHDJuC/zv6C0uS70YkBAoN7lVb64+qBCC
         2Uj4Ra1dg1Y7NRD+F1R68/x+NJDOVC0jezpfKzNyIPC8MX3Dv581rQ7UPLLoE/Exbw
         IcJp+8V1+z+gCiTzqMcoHGNsBqI5djJuHmLLyOtPuUsepsr5PuPj/5/2CdhguteDto
         5x3vFBx5Mn5yp3hXrLxBlgph1ZayG0kMo53CqKIHSqBbWA/clvdDx0fJMwfnAZbHa1
         AUJcwlzb+JKLyGJ9H3hazgZKS5J5TObuZ7FbQI1JCNW87SdFjRVhxbETAei6dRa6Ia
         mnWhHVkqbDY2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        ebiederm@xmission.com, wangkefeng.wang@huawei.com,
        rmk+kernel@armlinux.org.uk, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 182/188] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 17 Jan 2022 21:31:46 -0500
Message-Id: <20220118023152.1948105-182-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 9e9d4b460f23bab61672eae397417d03917d116c ]

In handle_interruption(), we call faulthandler_disabled() to check whether the
fault handler is not disabled. If the fault handler is disabled, we immediately
call do_page_fault(). It then calls faulthandler_disabled(). If disabled,
do_page_fault() attempts to fixup the exception by jumping to no_context:

no_context:

        if (!user_mode(regs) && fixup_exception(regs)) {
                return;
        }

        parisc_terminate("Bad Address (null pointer deref?)", regs, code, address);

Apart from the error messages, the two blocks of code perform the same
function.

We can avoid two calls to faulthandler_disabled() by a simple revision
to the code in handle_interruption().

Note: I didn't try to fix the formatting of this code block.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 197cb8480350c..afe8b902a8fc4 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -784,7 +784,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0 && !faulthandler_disabled())
+	    if (faulthandler_disabled() || fault_space == 0)
 	    {
 		/* Clean up and return if in exception table. */
 		if (fixup_exception(regs))
-- 
2.34.1

