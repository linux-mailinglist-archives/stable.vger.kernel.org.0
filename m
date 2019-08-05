Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21BA8119A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHEFa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:30:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55695 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbfHEFa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:30:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AAC7B21785;
        Mon,  5 Aug 2019 01:30:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=noPXGu
        iGKuy+BfZ2TnOrbS8RP8ll9LKeGjuBJbniTzY=; b=eP8DrUPy/UBU9vDEAFy9Y+
        oNQxLI3ZCRloqc1PmH8+s6XNJxolO+Dd4N7vRUWFnyXD4ynALEKkeCSJfTb1cOfe
        GnMb+7Elr0x22RnjQrqwUGT8nFERZXmqqGd0UX+i/N+s9jFAfHJZJ+cE93Tu7Zt8
        0QbqWw6Fhvf++CL7WRoNCzKVKe1/Y0m47Aq94RB5rhX0nF8tQcDRPb6ebkRefhna
        Rzy5NA1Wdn3vYnSfUUnKaC4rx6H4rTVoDqwI3W6pVE6+8oQnmjM3mT6a8m1MKdfC
        zNU432fm2blw81rrQvMgu8lI2hYm+nccRq2Qpo68WbaBpJXVCuyZuFovPi+UjGfQ
        ==
X-ME-Sender: <xms:Eb9HXTXT18KQXceElZgEXyCzyaDMtg_OZ3x_JhAIrYH6rjm3LC3Q0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Eb9HXXRizyPh-9O15F7fS5mbkGcMrkQfDjqYiOKFGXVa58M6hfmSgQ>
    <xmx:Eb9HXWQbI7kd7NMbgl1MbQxRpqdH7rlvJQIcjtAvbRBSXcBtciF7mg>
    <xmx:Eb9HXTJCq6Rf7Vz822pOSp3BRn8jciealrqzviRITFsWiGSg_tR1MQ>
    <xmx:Eb9HXTXaEbWlls0ESoLk813E73eKMmj_-AQqCD5MURpusNtPaXRQZw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCE6680062;
        Mon,  5 Aug 2019 01:30:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] parisc: fix race condition in patching code" failed to apply to 5.2-stable tree
To:     svens@stackframe.org, deller@gmx.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:30:55 +0200
Message-ID: <1564983055189121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 740f05f30a8c49ec63668055d28feedd906d3c50 Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@stackframe.org>
Date: Tue, 23 Jul 2019 22:37:54 +0200
Subject: [PATCH] parisc: fix race condition in patching code

Assume the following ftrace code sequence that was patched in earlier by
ftrace_make_call():

PAGE A:
ffc:	addr of ftrace_caller()
PAGE B:
000:	0x6fc10080 /* stw,ma r1,40(sp) */
004:	0x48213fd1 /* ldw -18(r1),r1 */
008:	0xe820c002 /* bv,n r0(r1) */
00c:	0xe83f1fdf /* b,l,n .-c,r1 */

When a Code sequences that is to be patched spans a page break, we might
have already cleared the part on the PAGE A. If an interrupt is coming in
during the remap of the fixed mapping to PAGE B, it might execute the
patched function with only parts of the FTRACE code cleared. To prevent
this, clear the jump to our mini trampoline first, and clear the remaining
parts after this. This might also happen when patch_text() patches a
function that it calls during remap.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: <stable@vger.kernel.org> # 5.2+
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index d784ccdd8fef..b6fb30f2e4bf 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -181,8 +181,9 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 	for (i = 0; i < ARRAY_SIZE(insn); i++)
 		insn[i] = INSN_NOP;
 
+	__patch_text((void *)rec->ip, INSN_NOP);
 	__patch_text_multiple((void *)rec->ip + 4 - sizeof(insn),
-			      insn, sizeof(insn));
+			      insn, sizeof(insn)-4);
 	return 0;
 }
 #endif

