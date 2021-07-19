Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AB3CDC17
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241195AbhGSOvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344279AbhGSOso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DA061287;
        Mon, 19 Jul 2021 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708463;
        bh=GUnLCwqGq+Q1BY2Di5mdFrrVM7TVqfE4gqATT0VHGZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHW2Ptaldz3rTUhmPrkIlC/HubOIh65Xd/oZ2vP3jDvsK7pUxC3JDtKI0KGC3YgQp
         i578stM/jFyfwaGDIdLzIg8+kDgATlxFoTBHtLoCFDQX6/LUwtvVyBk91nJ1KDIKVj
         MGxlPAY5VL/DVbLUxKBYe0goLRe4eD7HkywlrNMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 295/315] x86/fpu: Limit xstate copy size in xstateregs_set()
Date:   Mon, 19 Jul 2021 16:53:04 +0200
Message-Id: <20210719144953.166987065@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 07d6688b22e09be465652cf2da0da6bf86154df6 ]

If the count argument is larger than the xstate size, this will happily
copy beyond the end of xstate.

Fixes: 91c3dba7dbc1 ("x86/fpu/xstate: Fix PTRACE frames for XSAVES")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210623121452.120741557@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/regset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index bc02f5144b95..621d249ded0b 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -128,7 +128,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if ((pos != 0) || (count < fpu_user_xstate_size))
+	if (pos != 0 || count != fpu_user_xstate_size)
 		return -EFAULT;
 
 	xsave = &fpu->state.xsave;
-- 
2.30.2



