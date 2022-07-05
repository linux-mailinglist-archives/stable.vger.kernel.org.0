Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D835A566D51
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiGEMWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiGEMTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D57B18E1A;
        Tue,  5 Jul 2022 05:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 407ADB8170A;
        Tue,  5 Jul 2022 12:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A02C341C7;
        Tue,  5 Jul 2022 12:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023311;
        bh=Ksb1/PcP0ywMCJuFBLWwNgkMw+7Bu7olf1MzbZcnlgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bq/v9Q6yWmX7hOGnl+Ur4DbYu0Vw/H9G/95xdJjKwOkAlWQ1EukcNRExWdLQ7PGCR
         EZErdFKoeo5OeWyH1+m8fJhK/hmnkcP2i1jxadmRdT9p0GXXw69igJQeh9FMDlvGPq
         XW4dcYl7SzPyKoteWGJYoEXjN7O7Zg9eGsZpvVPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 015/102] parisc/unaligned: Fix emulate_ldw() breakage
Date:   Tue,  5 Jul 2022 13:57:41 +0200
Message-Id: <20220705115618.848258989@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 96b80fcd2705fc50ebe1f7f3ce204e861b3099ab upstream.

The commit e8aa7b17fe41 broke the 32-bit load-word unalignment exception
handler because it calculated the wrong amount of bits by which the value
should be shifted. This patch fixes it.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: e8aa7b17fe41 ("parisc/unaligned: Rewrite inline assembly of emulate_ldw()")
Cc: stable@vger.kernel.org   # v5.18
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/unaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index ed1e88a74dc4..bac581b5ecfc 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -146,7 +146,7 @@ static int emulate_ldw(struct pt_regs *regs, int toreg, int flop)
 "	depw	%%r0,31,2,%4\n"
 "1:	ldw	0(%%sr1,%4),%0\n"
 "2:	ldw	4(%%sr1,%4),%3\n"
-"	subi	32,%4,%2\n"
+"	subi	32,%2,%2\n"
 "	mtctl	%2,11\n"
 "	vshd	%0,%3,%0\n"
 "3:	\n"
-- 
2.37.0



