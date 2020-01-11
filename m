Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67145138048
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbgAKK1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:27:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbgAKK1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:27:52 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68AA220880;
        Sat, 11 Jan 2020 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738472;
        bh=OUtdEcKKm9GCfSQ/foIneGkdTaGiXgZyeKxgLROz668=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGNP/vAw6Z07JmLz+igtIcUaK+lyMjS4N1QpWqN/M0g1XRGtY8J8MqdeXvIGoKW6G
         lX/XxoOMEQeWGtTTawBjxNuG/S1EAK955vP671U8NkF87By7UdRlMrPpOPiC5VPnRb
         Ne5lR8zgNa0C9dnlldQKktwXNmacnNcE6X0kSpKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Jingfeng Xie <xiejingfeng@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/165] psi: Fix a division error in psi poll()
Date:   Sat, 11 Jan 2020 10:50:20 +0100
Message-Id: <20200111094930.155151632@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit c3466952ca1514158d7c16c9cfc48c27d5c5dc0f ]

The psi window size is a u64 an can be up to 10 seconds right now,
which exceeds the lower 32 bits of the variable. We currently use
div_u64 for it, which is meant only for 32-bit divisors. The result is
garbage pressure sampling values and even potential div0 crashes.

Use div64_u64.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jingfeng Xie <xiejingfeng@linux.alibaba.com>
Link: https://lkml.kernel.org/r/20191203183524.41378-3-hannes@cmpxchg.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 970db4686dd4..ce8f6748678a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -482,7 +482,7 @@ static u64 window_update(struct psi_window *win, u64 now, u64 value)
 		u32 remaining;
 
 		remaining = win->size - elapsed;
-		growth += div_u64(win->prev_growth * remaining, win->size);
+		growth += div64_u64(win->prev_growth * remaining, win->size);
 	}
 
 	return growth;
-- 
2.20.1



