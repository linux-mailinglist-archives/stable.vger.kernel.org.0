Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2986C3687E4
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 22:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhDVUaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 16:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbhDVUaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 16:30:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9040FC061756;
        Thu, 22 Apr 2021 13:29:36 -0700 (PDT)
Message-Id: <20210422194704.834797921@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619123375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=HpKOt0EBb2THQk50nWseDhXHTlRl5ZX7JEsYWRDnUg8=;
        b=tY5mQfNPoDMftcKZdxpVuysa2qBYPBSt6i/jiCUKOyehwsAKVyMHHqrSuigD/LY2uewG1F
        mIGJTzWsgXESTim7wqP4GRKK/4YEpcGEgTcwoV2pCcm/6MjSHSVELasZe02R/npgfus59o
        1foME4dIHgAXK3lJL7g345NiGCMyp6hHjhSyH6PGcN/Lu5PwdqKI05niAwXXBbxreNYB9k
        BQxgQDquJOepqppV1UAQW8+ph0ihqAMThoFhOfpxTLcUUar2+ZwYQGFbkgMMuoqfsXCESu
        f71IUBgH1uuqaGVWkCsSkPBzH2dyhhpqH32tzIup66vw9tMoXkmMArKsfAHneg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619123375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=HpKOt0EBb2THQk50nWseDhXHTlRl5ZX7JEsYWRDnUg8=;
        b=HNpo+nmPqXgOeSvWSSo1T/HvHvYMN21bEI2L1kDbhY4zsWzADPaRrNNorLlfZhPMtU3iru
        dwNee7Miov7nDlCg==
Date:   Thu, 22 Apr 2021 21:44:18 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        Lukasz Majewski <lukma@denx.de>,
        Florian Weimer <fweimer@redhat.com>,
        Carlos O'Donell <carlos@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andrei Vagin <avagin@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [patch 1/6] Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME
 with FUTEX_WAIT op")
References: <20210422194417.866740847@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Cc: Darren Hart <dvhart@infradead.org>
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
 

