Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857F6491D85
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344624AbiARDiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352407AbiARDe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:34:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4E3C03702D;
        Mon, 17 Jan 2022 19:09:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18588B8122C;
        Tue, 18 Jan 2022 03:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CAAC36AEB;
        Tue, 18 Jan 2022 03:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475376;
        bh=nF1g3TlmBQAjvdwYb0PgfScODMcjqpRH4mw4fHaeTBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcV4w/8eq8uQzKUw11VpKr2IT/9JDtD956qHlhRQJ4WS+vG/F+FlgFp2JbGJJP4yQ
         lYhQNXYnhiGXBfA88El/TpPLt6kxaF9ypNG6GtWB921iBIeXQB0cxoOAJ3jpK/YgJr
         fWCY4oTEZwE4xAPe5KOpW4i/HVL4wf8cTUI8BmHtZUPC7Llg7GwhUa3QVDP0gUvJPp
         YTI7YVJCp79OHDDi4WsYFC+KZCKhfIag5BL8AQwj/3fHo3+1zJjOfDPFzuFyYkGjyI
         wKF/nkjwpybtWfutHDba7kw4AgOtPNp9WKmcF/mq3Iml4WIMY+ucnbaIcrX6aeBekj
         M6XjjR4dvLP1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        rmk+kernel@armlinux.org.uk, wangkefeng.wang@huawei.com,
        ebiederm@xmission.com, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 29/29] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 17 Jan 2022 22:08:22 -0500
Message-Id: <20220118030822.1955469-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
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
index 6f61a17e2485a..55e7ba06511df 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -796,7 +796,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0 && !faulthandler_disabled())
+	    if (faulthandler_disabled() || fault_space == 0)
 	    {
 		/* Clean up and return if in exception table. */
 		if (fixup_exception(regs))
-- 
2.34.1

