Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B794973D6D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390910AbfGXTu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391586AbfGXTu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:50:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8A820659;
        Wed, 24 Jul 2019 19:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997827;
        bh=PnkC2LTDZuIcwwAJ99NHnnP7Cmp2QjzGZpMgYPKqKtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMieNJkW+5jG3ulFW87/qWE9a/HKKCMR+cA/q4vVlbxprxaH1Uy9A+K8ZWfFZ87rh
         tKL8vnfvdsxiW2YjuJiQEmKoi9OHuZSk0diRw1i7Rr9WNnU35qI/z3DG5B6lLQ68U6
         4ckkFeidODMoZfG8FmEM8oATbwHhxA395/Zzp0+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 156/371] xsk: Properly terminate assignment in xskq_produce_flush_desc
Date:   Wed, 24 Jul 2019 21:18:28 +0200
Message-Id: <20190724191736.917136789@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f7019b7b0ad14bde732b8953161994edfc384953 ]

Clang warns:

In file included from net/xdp/xsk_queue.c:10:
net/xdp/xsk_queue.h:292:2: warning: expression result unused
[-Wunused-value]
        WRITE_ONCE(q->ring->producer, q->prod_tail);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
        __u.__val;                                      \
        ~~~ ^~~~~
1 warning generated.

The q->prod_tail assignment has a comma at the end, not a semi-colon.
Fix that so clang no longer warns and everything works as expected.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Link: https://github.com/ClangBuiltLinux/linux/issues/544
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 610c0bdc0c2b..cd333701f4bf 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -240,7 +240,7 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 	/* Order producer and data */
 	smp_wmb();
 
-	q->prod_tail = q->prod_head,
+	q->prod_tail = q->prod_head;
 	WRITE_ONCE(q->ring->producer, q->prod_tail);
 }
 
-- 
2.20.1



