Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042DF2B650D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgKQN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbgKQN2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB9D320781;
        Tue, 17 Nov 2020 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619717;
        bh=xNzIYruHbZwGWlvomLEXiR6gRfnXMwxV3iQA7ugjKoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q51jb4es5GOs/Bt1WdykHzfxMD5RR+G4w0ZGG43Oc6dmf8XOpzGwrb+58Hiq29A8e
         DUsYCgMFgqVYW+GCOE3cEw3Uoxa+L4GgqhF6sa3NBvvADbGE1XTeHSi9c8QgXN2s+m
         1USII5L95DmjzSKMquGP4z+teDWK6a+u0CQJsDKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/151] perf: Fix get_recursion_context()
Date:   Tue, 17 Nov 2020 14:05:35 +0100
Message-Id: <20201117122126.522066297@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ce0f17fc93f63ee91428af10b7b2ddef38cd19e5 ]

One should use in_serving_softirq() to detect SoftIRQ context.

Fixes: 96f6d4444302 ("perf_counter: avoid recursion")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201030151955.120572175@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 3aef4191798c3..6e87b358e0826 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -210,7 +210,7 @@ static inline int get_recursion_context(int *recursion)
 		rctx = 3;
 	else if (in_irq())
 		rctx = 2;
-	else if (in_softirq())
+	else if (in_serving_softirq())
 		rctx = 1;
 	else
 		rctx = 0;
-- 
2.27.0



