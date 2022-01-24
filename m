Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A5A498CA2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347289AbiAXTXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:23:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343636AbiAXTV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:21:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90A1EB8121A;
        Mon, 24 Jan 2022 19:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A54C340E5;
        Mon, 24 Jan 2022 19:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052086;
        bh=1rb8EM3XDFWr+VyTcb3Rfus7JTqCNfeY0zVb9E/f6mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tpg51rJ8glNdt6DyvsTDgA4/8dGNkx2DZpTaoaWUFJX8YURP7cYvB2VP0RedTkqfG
         Sd3jCbNjaInUACjSIrTXB4MpEjug8DBdzDsECLsL/OYZO+D6lCFitZ0E+8nRBK9EGB
         lDGL1ZJnYpTz3yvMLN3ZfUoY3nN1bHE4fpvi69qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/239] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 24 Jan 2022 19:43:35 +0100
Message-Id: <20220124183948.728992883@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index abeb5321a83fc..d7a66d8525091 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -750,7 +750,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0 && !faulthandler_disabled())
+	    if (faulthandler_disabled() || fault_space == 0)
 	    {
 		/* Clean up and return if in exception table. */
 		if (fixup_exception(regs))
-- 
2.34.1



