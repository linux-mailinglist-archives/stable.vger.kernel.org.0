Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665E242DCD2
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhJNPCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhJNPAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69B7600CC;
        Thu, 14 Oct 2021 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223502;
        bh=ItayDj/C0c55vlAJ2QcY9yEmJMIb4DyCxDwFeUMOUB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywhWTqGgGLUlGFxkF5M0suswxjXyM+ZAoKUjrUBrDfYIY3wUUqM/mvbHp2YmS1g0U
         ypIub+4Vm83vfN1HS5zGc5rBm0N3k6kKwTpTEVq3ETnwns6e3jcoCTOlyZyhZEBlyg
         TQI1nasdNJAdmnaHkwR21nL/3GV06k0d9VK8CIwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/12] sched: Always inline is_percpu_thread()
Date:   Thu, 14 Oct 2021 16:54:12 +0200
Message-Id: <20211014145206.950124773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
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
index 5524cd5c6abe..761d0f85c4a5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1433,7 +1433,7 @@ extern struct pid *cad_pid;
 #define tsk_used_math(p)			((p)->flags & PF_USED_MATH)
 #define used_math()				tsk_used_math(current)
 
-static inline bool is_percpu_thread(void)
+static __always_inline bool is_percpu_thread(void)
 {
 #ifdef CONFIG_SMP
 	return (current->flags & PF_NO_SETAFFINITY) &&
-- 
2.33.0



