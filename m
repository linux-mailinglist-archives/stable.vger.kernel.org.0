Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181C0498B42
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346302AbiAXTMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36368 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346886AbiAXTJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:09:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10DD6B811FC;
        Mon, 24 Jan 2022 19:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7194CC340E5;
        Mon, 24 Jan 2022 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051343;
        bh=qbuJzMLstbf2L54xjwrmp0834IdyaWQYNr1ugUCfyB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP02YYYTqq3fkpz6XoYa/UdxLTMxMo8p+FMr94cbK2dDlmFJkzWA3ucXP1r1x1lFq
         Y37jRMukH9eVk2/r78Os1f6Fxxe8RwU2aMkWx0+ovEpUsc5RhVH8a07Sy4Rr7blhFQ
         RbRYMgUf8NiceG4S1o8JIDmv4tC/5vq371Bw1G4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/186] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 24 Jan 2022 19:43:26 +0100
Message-Id: <20220124183941.326282967@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
index 9a898d68f4a0d..346456c43aa0b 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -795,7 +795,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0 && !faulthandler_disabled())
+	    if (faulthandler_disabled() || fault_space == 0)
 	    {
 		/* Clean up and return if in exception table. */
 		if (fixup_exception(regs))
-- 
2.34.1



