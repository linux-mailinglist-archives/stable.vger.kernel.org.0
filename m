Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DE65A496E
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiH2LYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiH2LXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEF21260A;
        Mon, 29 Aug 2022 04:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89770B80EF8;
        Mon, 29 Aug 2022 11:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A17C433C1;
        Mon, 29 Aug 2022 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771220;
        bh=ovzaeclTwx3JGQ15R2yV043ygdNtkNJfgphs9BmP63I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EL9Xm222Ck8hOwlYs/T59xKFs573DkLD8tm/E5OzRp5/wj8r43+AQ6xgUaSE6G8ne
         TdUrJJocpZ7N4uE4CGAVFqdjy8kQkyeI1X6vzEPDovEXsizDF6GoNVn7nnsvQNUwcT
         97Z1Tu6ii7LcW8pHuf+r0B0mSb/qELJboRHfSHFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.19 006/158] parisc: Fix exception handler for fldw and fstw instructions
Date:   Mon, 29 Aug 2022 12:57:36 +0200
Message-Id: <20220829105809.105780974@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 7ae1f5508d9a33fd58ed3059bd2d569961e3b8bd upstream.

The exception handler is broken for unaligned memory acceses with fldw
and fstw instructions, because it trashes or uses randomly some other
floating point register than the one specified in the instruction word
on loads and stores.

The instruction "fldw 0(addr),%fr22L" (and the other fldw/fstw
instructions) encode the target register (%fr22) in the rightmost 5 bits
of the instruction word. The 7th rightmost bit of the instruction word
defines if the left or right half of %fr22 should be used.

While processing unaligned address accesses, the FR3() define is used to
extract the offset into the local floating-point register set.  But the
calculation in FR3() was buggy, so that for example instead of %fr22,
register %fr12 [((22 * 2) & 0x1f) = 12] was used.

This bug has been since forever in the parisc kernel and I wonder why it
wasn't detected earlier. Interestingly I noticed this bug just because
the libime debian package failed to build on *native* hardware, while it
successfully built in qemu.

This patch corrects the bitshift and masking calculation in FR3().

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/unaligned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -93,7 +93,7 @@
 #define R1(i) (((i)>>21)&0x1f)
 #define R2(i) (((i)>>16)&0x1f)
 #define R3(i) ((i)&0x1f)
-#define FR3(i) ((((i)<<1)&0x1f)|(((i)>>6)&1))
+#define FR3(i) ((((i)&0x1f)<<1)|(((i)>>6)&1))
 #define IM(i,n) (((i)>>1&((1<<(n-1))-1))|((i)&1?((0-1L)<<(n-1)):0))
 #define IM5_2(i) IM((i)>>16,5)
 #define IM5_3(i) IM((i),5)


