Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096C042DD2F
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhJNPE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhJNPDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE36600CC;
        Thu, 14 Oct 2021 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223608;
        bh=rUpU6d7I/rjWnXWPTeF77Q7rPePYGfLojaCiLxzQS+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GE/4rUoqR5XHg+JVp0mtsou6FiGt7Dd8WmMDfy+vUeWkjCs94puxnVQZJ55VGhuY/
         TTQaU59muX5QycuaZ5zlhNTQz/gSQdyTzAXzyzl+Ax6Jf9XlbVtpknhy9NDv8toboo
         nLio8Kh4M6JFpPI/Nr9r8ng1aUvoLqTVv02+c20s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/22] sched: Always inline is_percpu_thread()
Date:   Thu, 14 Oct 2021 16:54:27 +0200
Message-Id: <20211014145208.659260923@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 83d40a61046f73103b4e5d8f1310261487ff63b0 ]

  vmlinux.o: warning: objtool: check_preemption_disabled()+0x81: call to is_percpu_thread() leaves .noinstr.text section

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210928084218.063371959@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 29c7ccd5ae42..b85b26d9ccef 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1589,7 +1589,7 @@ extern struct pid *cad_pid;
 #define tsk_used_math(p)			((p)->flags & PF_USED_MATH)
 #define used_math()				tsk_used_math(current)
 
-static inline bool is_percpu_thread(void)
+static __always_inline bool is_percpu_thread(void)
 {
 #ifdef CONFIG_SMP
 	return (current->flags & PF_NO_SETAFFINITY) &&
-- 
2.33.0



