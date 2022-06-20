Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B34551BAC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347784AbiFTNpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349319AbiFTNoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0586C2CC9C;
        Mon, 20 Jun 2022 06:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF3A660FEF;
        Mon, 20 Jun 2022 13:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD77AC3411B;
        Mon, 20 Jun 2022 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730956;
        bh=N/NIA5jKRGapFcBKcTH4xUISDWf3g0Dhrm0AZVeEJeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7ndhfkzF2hFrMtf862CQtgAvyvms9kEDuR7wp+X+XEOtM0F//P2ih9wklTxpA82j
         QLCQGbHQP70KU03eWGELiegYTYWXIouKr4am80wfP2492gSIAVdwUw8UA5KmfQfD3u
         ioSPiggmXOOoJlQXEJsN3jjYoxpptU5IhTUQQB+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 106/240] random: round-robin registers as ulong, not u32
Date:   Mon, 20 Jun 2022 14:50:07 +0200
Message-Id: <20220620124742.086819101@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit da3951ebdcd1cb1d5c750e08cd05aee7b0c04d9a upstream.

When the interrupt handler does not have a valid cycle counter, it calls
get_reg() to read a register from the irq stack, in round-robin.
Currently it does this assuming that registers are 32-bit. This is
_probably_ the case, and probably all platforms without cycle counters
are in fact 32-bit platforms. But maybe not, and either way, it's not
quite correct. This commit fixes that to deal with `unsigned long`
rather than `u32`.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1256,15 +1256,15 @@ int random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
+static unsigned long get_reg(struct fast_pool *f, struct pt_regs *regs)
 {
-	u32 *ptr = (u32 *)regs;
+	unsigned long *ptr = (unsigned long *)regs;
 	unsigned int idx;
 
 	if (regs == NULL)
 		return 0;
 	idx = READ_ONCE(f->reg_idx);
-	if (idx >= sizeof(struct pt_regs) / sizeof(u32))
+	if (idx >= sizeof(struct pt_regs) / sizeof(unsigned long))
 		idx = 0;
 	ptr += idx++;
 	WRITE_ONCE(f->reg_idx, idx);


