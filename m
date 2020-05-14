Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C71D3A48
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgENSzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbgENSzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DFFA2081A;
        Thu, 14 May 2020 18:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482519;
        bh=4+p9Et0PJxrEXamW6haclt6TvsWygj2K5WYzhSpxuRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzyVx6gv1zSgTkFaAJqbG4Lp6IKKZ8CfSOAYHoB5oKe1pr4EG444N+vZFWrdqpOi/
         fAoCQoXfN8UdubNA9LXxz6+0fRNdwYDgRkJ6yEdNLipeQtAaH1p4aqwoGobF22BixB
         5uiGWxwvf06IEiy94pNTHWG6D+ahc6hWzWr4pWcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 15/39] x86/unwind/orc: Fix error path for bad ORC entry type
Date:   Thu, 14 May 2020 14:54:32 -0400
Message-Id: <20200514185456.21060-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit a0f81bf26888048100bf017fadf438a5bdffa8d8 ]

If the ORC entry type is unknown, nothing else can be done other than
reporting an error.  Exit the function instead of breaking out of the
switch statement.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Jones <dsj@fb.com>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lore.kernel.org/r/a7fa668ca6eabbe81ab18b2424f15adbbfdc810a.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 8a855867e4568..19a02c47d76c7 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -460,7 +460,7 @@ bool unwind_next_frame(struct unwind_state *state)
 	default:
 		orc_warn("unknown .orc_unwind entry type %d for ip %pB\n",
 			 orc->type, (void *)orig_ip);
-		break;
+		goto err;
 	}
 
 	/* Find BP: */
-- 
2.20.1

