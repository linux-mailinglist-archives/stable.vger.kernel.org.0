Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2CE5A47FD
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiH2LET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiH2LDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:03:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130E3642CA;
        Mon, 29 Aug 2022 04:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0F80B80EF9;
        Mon, 29 Aug 2022 11:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6C3C433D7;
        Mon, 29 Aug 2022 11:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770949;
        bh=NajXgsYiuauLyQeZ+zf17PKBvQW9QaVX+z7efwu5PKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sS1UfMCDrp6I9L5RvZwcinFxghQvCvIWDlJQQN37CVToOrgz7m19EXZ00VL7ITCkC
         GGTxxZF4QRbg0ch3aThOsATI4DXEk/yDEaNcd4IXF4nsmrKf5ke+G1R+OZKc/4qHG2
         MT6JyolaYTPgFQC7KySsdQRjlPzIbuj1ovnhpFPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 006/136] parisc: Fix exception handler for fldw and fstw instructions
Date:   Mon, 29 Aug 2022 12:57:53 +0200
Message-Id: <20220829105804.898621363@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
@@ -107,7 +107,7 @@
 #define R1(i) (((i)>>21)&0x1f)
 #define R2(i) (((i)>>16)&0x1f)
 #define R3(i) ((i)&0x1f)
-#define FR3(i) ((((i)<<1)&0x1f)|(((i)>>6)&1))
+#define FR3(i) ((((i)&0x1f)<<1)|(((i)>>6)&1))
 #define IM(i,n) (((i)>>1&((1<<(n-1))-1))|((i)&1?((0-1L)<<(n-1)):0))
 #define IM5_2(i) IM((i)>>16,5)
 #define IM5_3(i) IM((i),5)


