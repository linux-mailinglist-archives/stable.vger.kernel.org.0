Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CA49187D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346365AbiARCrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:47:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36566 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346221AbiARCoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:44:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 819BA6093C;
        Tue, 18 Jan 2022 02:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60D3C36AEB;
        Tue, 18 Jan 2022 02:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473863;
        bh=sPspLDjSwcA/+CaLh+o2OAKsp197ZqFntPnughJxxdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGCpr1xLnoXHeFAYK2iZVyaEuG7ytSq2hfwJ/g06Olw6Ol+uLeggEWBJ4B7maXFRX
         6QK+eOLzQmtEsJ0ww3IleMXKe2HgoPYE6FEDWQv9arKTVy0EKXffHPln24SjhDloPq
         mWYOZJm1Ik1QEccpIXJOu5qXP35IsqHbfH/B7Id4R/uxKJu5K9LglsnUxCqkmGn+ar
         1Z4LSykEAGUBgZIJAivGn0yJk3MSvm3rIveJEvJ9IC39flCo/p+CDfP2ug0pOhdUku
         Ei3xeosJBlfwl0q5AKR11OhqvTl7b01FJSV4+vVGECPtikq4oo6bmclVSd0C8jKWqy
         QvYQsYGMB3v7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        rmk+kernel@armlinux.org.uk, akpm@linux-foundation.org,
        mpe@ellerman.id.au, wangkefeng.wang@huawei.com,
        ebiederm@xmission.com, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 113/116] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 17 Jan 2022 21:40:04 -0500
Message-Id: <20220118024007.1950576-113-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 43f56335759a4..269b737d26299 100644
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

