Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F235242DD3A
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhJNPFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232909AbhJNPBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF0060F36;
        Thu, 14 Oct 2021 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223547;
        bh=Ic1Xl0EJlz1H6BWjK+QotJRMRFnTH66mGwyoc4yMAio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TK3g7Kc60Nf53U+5d0zLWVT3UXfsR5BHbNLXoGxb7KgqA0A3I8aT6o3TgwxAn/QOF
         dKPFMaXfXTRgsm68VITpZPrlUPvojPmRrfYge9ZDNg13z+hDCp5H1Gxhe7MjH2OH2L
         NUW3e0EiksgryUxQowHt5DBxdEcQzQ4XnlC2QGoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/16] sched: Always inline is_percpu_thread()
Date:   Thu, 14 Oct 2021 16:54:19 +0200
Message-Id: <20211014145207.835283624@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
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
index 5710b80f8050..afee5d5eb945 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1500,7 +1500,7 @@ extern struct pid *cad_pid;
 #define tsk_used_math(p)			((p)->flags & PF_USED_MATH)
 #define used_math()				tsk_used_math(current)
 
-static inline bool is_percpu_thread(void)
+static __always_inline bool is_percpu_thread(void)
 {
 #ifdef CONFIG_SMP
 	return (current->flags & PF_NO_SETAFFINITY) &&
-- 
2.33.0



