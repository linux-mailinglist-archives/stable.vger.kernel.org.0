Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69DB378901
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbhEJLZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235318AbhEJLOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:14:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B0C961075;
        Mon, 10 May 2021 11:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645056;
        bh=id582z2zHgIDtFnlOdn0Ci+tIXY+YTX5iV853NXKwEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wr/Rj2Qf+4OqRlOsBMMRW9thLqW0XzyNnFiHd9JpKSOk7FTsO7OHvohq6nuvz9fEc
         9BX/cDDcjnL4qUc9872GSQNz47Nl7EIX8IG/PcWiAwLE/vEkoDXgE0m7cqVZA341aK
         ABzqbwFdmsWo53tF7BBDbu3mmHQtACWDlS9FDa3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.12 332/384] Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
Date:   Mon, 10 May 2021 12:22:01 +0200
Message-Id: <20210510102025.735241788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4fbf5d6837bf81fd7a27d771358f4ee6c4f243f8 upstream.

The FUTEX_WAIT operand has historically a relative timeout which means that
the clock id is irrelevant as relative timeouts on CLOCK_REALTIME are not
subject to wall clock changes and therefore are mapped by the kernel to
CLOCK_MONOTONIC for simplicity.

If a caller would set FUTEX_CLOCK_REALTIME for FUTEX_WAIT the timeout is
still treated relative vs. CLOCK_MONOTONIC and then the wait arms that
timeout based on CLOCK_REALTIME which is broken and obviously has never
been used or even tested.

Reject any attempt to use FUTEX_CLOCK_REALTIME with FUTEX_WAIT again.

The desired functionality can be achieved with FUTEX_WAIT_BITSET and a
FUTEX_BITSET_MATCH_ANY argument.

Fixes: 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210422194704.834797921@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3711,8 +3711,7 @@ long do_futex(u32 __user *uaddr, int op,
 
 	if (op & FUTEX_CLOCK_REALTIME) {
 		flags |= FLAGS_CLOCKRT;
-		if (cmd != FUTEX_WAIT && cmd != FUTEX_WAIT_BITSET && \
-		    cmd != FUTEX_WAIT_REQUEUE_PI)
+		if (cmd != FUTEX_WAIT_BITSET &&	cmd != FUTEX_WAIT_REQUEUE_PI)
 			return -ENOSYS;
 	}
 


