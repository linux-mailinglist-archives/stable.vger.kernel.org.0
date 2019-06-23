Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AEA4FDF8
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFWU1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:27:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60253 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbfFWU1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:27:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F2845220FF;
        Sun, 23 Jun 2019 16:27:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ScdFtN
        a6uOXm9oXiDs7N0UQYosVRJzL58c6hpFjOXVg=; b=sXTNAL+a4qh/3ZSQnWOe1g
        ary8qHJbpKD0GECSIIxiFzU2XpXxYk14Q4smT/Ku0cWSoz3A1hz4IHV/zGC7Ro/M
        Y9xNQWOnvJnNswZ2102LWFfSLFiblgemW20Qn+cNtNiRq5UALZTOpI2sL8d32EF6
        ovW9A85Nc1GBMeBvAdVavixORUFbOOHWdmxjOvzOY8aWrIj1qazu6oQVSvktH9WR
        QVCqLwW0QMgjagwfGk+d9XQLps3PdMVbSSZmcwORDC70blTlwW5+k/7aAzztI9Oq
        oLuuClfG8dVsBjGp4pZQblWcB/jOXahFSbjsp+zfYUyswvTNeG6qmlKcnofaqmZw
        ==
X-ME-Sender: <xms:muAPXXh-6xigrRF-OL1yPhhlEPul0zopicrtVMlx6YPVHgTqEOdCJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:muAPXYSeqXcJoq4gqAXmN1h3JbntSIYIegOhexLOPuI60G7KlC7rVg>
    <xmx:muAPXSED_rK91LAXU-xoVxGHm05snO33CJ4F_58KnR9eka30u25-8g>
    <xmx:muAPXYkEYvwl8zgEsHVtCSR9CDZL9NJzZEtcWouJgPIEPW9v8OzDOg>
    <xmx:muAPXbGrySSrMvL_MihFdjXi5UOMT6gC9DA0eMnGoCm_mAbIN6zXOg>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA5938005B;
        Sun, 23 Jun 2019 16:27:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: ssbd: explicitly depend on <linux/prctl.h>" failed to apply to 4.14-stable tree
To:     aastier@freebox.fr, will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:26:50 +0200
Message-ID: <156132161027249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From adeaa21a4b6954e878f3f7d1c5659ed9c1fe567a Mon Sep 17 00:00:00 2001
From: Anisse Astier <aastier@freebox.fr>
Date: Mon, 17 Jun 2019 15:22:21 +0200
Subject: [PATCH] arm64: ssbd: explicitly depend on <linux/prctl.h>

Fix ssbd.c which depends implicitly on asm/ptrace.h including
linux/prctl.h (through for example linux/compat.h, then linux/time.h,
linux/seqlock.h, linux/spinlock.h and linux/irqflags.h), and uses
PR_SPEC* defines.

This is an issue since we'll soon be removing the include from
asm/ptrace.h.

Fixes: 9cdc0108baa8 ("arm64: ssbd: Add prctl interface for per-thread mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Anisse Astier <aastier@freebox.fr>
Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm64/kernel/ssbd.c b/arch/arm64/kernel/ssbd.c
index 885f13e58708..52cfc6148355 100644
--- a/arch/arm64/kernel/ssbd.c
+++ b/arch/arm64/kernel/ssbd.c
@@ -5,6 +5,7 @@
 
 #include <linux/compat.h>
 #include <linux/errno.h>
+#include <linux/prctl.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/thread_info.h>

