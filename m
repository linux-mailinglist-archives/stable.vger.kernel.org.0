Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B2249913D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378865AbiAXUJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58044 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353254AbiAXUBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:01:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB49D611CD;
        Mon, 24 Jan 2022 20:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCE4C340E7;
        Mon, 24 Jan 2022 20:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054488;
        bh=sPspLDjSwcA/+CaLh+o2OAKsp197ZqFntPnughJxxdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMyVPtQHdupblyZELIrIHw0ilOaQ4oMflYrHtVw0OZWyNwYkUbtfmAQEr9DtbVNsy
         yXA8S7kQQ+02LZtfo+olYtY3orM4uFf/ISFn7JteGO0Z1bYk5qOXwyzRRYj9xAssxM
         SRF6ubw+27MIxRaISSNH+Sj0zwM/4bTrsTzxWPKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/563] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 24 Jan 2022 19:42:51 +0100
Message-Id: <20220124184038.488134638@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



