Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14A83290CE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbhCAUPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235681AbhCAUFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:05:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F94365292;
        Mon,  1 Mar 2021 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621521;
        bh=dfiwfjdih95kPmNueKLfJksMl9tfBhr/oXqsr+opQjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5/QAdUKcsUHtOb9Nl3M+sFyM7Uc3SsFbpJ8dGuLOyH/zMCnaj2aRPSGyE12MQyWJ
         CQcyg2AsVHBST+YqUNUVv52MeQ5YUGEh7pPGnkT6F5Temr7RHkHZzM0ZhDkUyXSI07
         wr12LfyfYK8O0ccmTmkStI9lRVxdsRfiH82gkS54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Oetken <andreas.oetken@siemens.com>,
        Ley Foon Tan <ley.foon.tan@intel.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 529/775] nios2: fixed broken sys_clone syscall
Date:   Mon,  1 Mar 2021 17:11:37 +0100
Message-Id: <20210301161227.633145299@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Oetken <andreas.oetken@siemens.com>

[ Upstream commit 9abcfcb20320e8f693e89d86573b58e6289931cb ]

The tls pointer must be pushed on the stack prior to calling nios2_clone
as it is the 5th function argument. Prior handling of the tls pointer was
done inside former called function copy_thread_tls using the r8 register
from the current_pt_regs directly. This was a bad design and resulted in
the current bug introduced in 04bd52fb.

Fixes: 04bd52fb ("nios2: enable HAVE_COPY_THREAD_TLS, switch to kernel_clone_args")
Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
Signed-off-by: Ley Foon Tan <ley.foon.tan@intel.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/kernel/entry.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
index da8442450e460..0794cd7803dfe 100644
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -389,7 +389,10 @@ ENTRY(ret_from_interrupt)
  */
 ENTRY(sys_clone)
 	SAVE_SWITCH_STACK
+	subi    sp, sp, 4 /* make space for tls pointer */
+	stw     r8, 0(sp) /* pass tls pointer (r8) via stack (5th argument) */
 	call	nios2_clone
+	addi    sp, sp, 4
 	RESTORE_SWITCH_STACK
 	ret
 
-- 
2.27.0



