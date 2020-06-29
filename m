Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185C020E2ED
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390323AbgF2VKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgF2TAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C021F25515;
        Mon, 29 Jun 2020 15:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446072;
        bh=0hUpSfK+zwXDKbclbGkSB9eXNB46nBcPxc6b1vphWfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX0/kh3BH/Xfho7ZXnNiLdYcO85CTPUp+BAr+s4zF/Njhm9g6FxwIQT2/0mJzdoUZ
         j2ZALK9K5u+PAFeX0h4h+V1jK2Kiuy/7QCMWmPTyChb5DLq6r7/RUAYlnKYY0nkBDG
         IfxkN1Ybbb+poBzOJheVnw6Ddyfny5CFUBcvUEmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ziqian SUN <zsun@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 070/135] kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex
Date:   Mon, 29 Jun 2020 11:52:04 -0400
Message-Id: <20200629155309.2495516-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 1a0aa991a6274161c95a844c58cfb801d681eb59 ]

In kprobe_optimizer() kick_kprobe_optimizer() is called
without kprobe_mutex, but this can race with other caller
which is protected by kprobe_mutex.

To fix that, expand kprobe_mutex protected area to protect
kick_kprobe_optimizer() call.

Link: http://lkml.kernel.org/r/158927057586.27680.5036330063955940456.stgit@devnote2

Fixes: cd7ebe2298ff ("kprobes: Use text_poke_smp_batch for optimizing")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ziqian SUN <zsun@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f59f49bc2a5d5..430baa19e48c3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -561,11 +561,12 @@ static void kprobe_optimizer(struct work_struct *work)
 	do_free_cleaned_kprobes();
 
 	mutex_unlock(&module_mutex);
-	mutex_unlock(&kprobe_mutex);
 
 	/* Step 5: Kick optimizer again if needed */
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
 		kick_kprobe_optimizer();
+
+	mutex_unlock(&kprobe_mutex);
 }
 
 /* Wait for completing optimization and unoptimization */
-- 
2.25.1

