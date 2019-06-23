Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3A84FDF9
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFWU1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:27:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55981 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbfFWU1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:27:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AF928220DD;
        Sun, 23 Jun 2019 16:27:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WPLxcb
        CsSr39j403neoUoO7PvBH9vkF3R5FZhSUFy94=; b=ABIyEeLcCpTloHLF/DNzx5
        E+CQjg+IKPNxJUo3qC+7vAiA7y3yhe50WPIi810JxKvcKpUIDFT8WMnwQ+oKbq00
        /aNsq1OcggIyicbwLqWghgrWqqOzEykhfw2dXzTVy5bM+HIk2r3EOe935VItF88A
        yit8Gmi+8o+l8gRcAFLgOzQZJtoNtklV5Js2HmFd5eYZOmyZYDBZTmcXZVbW/Lv+
        ZUBc6YlOd9Y5R4QFXxog2JAm0kt7lOSpVVGBVDmrYcfWL6EmaWKHgVBkpt0Juu0l
        lsAratRh5bBvCGVhD+p+R0r54yF5rrRnh0SYvo1xET9JY3beHRWNoDwxNzb8yFfg
        ==
X-ME-Sender: <xms:seAPXZQAm1NxbD6ER6ECxb7tfJEncyR_HiOv6irUI4qvds8minJN2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:seAPXSUhr6ANgAFBJFBqDABdmfIullv1syIeC6m9TJ6kt2FL31iwKg>
    <xmx:seAPXYPev-KleCHYKJXaz9CRw0sBjU8cIEdHuBno2hO4vhrhDMXHvQ>
    <xmx:seAPXZ3XxNSHY536lBJPJRUPu5oHKYFNbPJ_6rgOerjHjtPazVei4A>
    <xmx:seAPXWajeRG1zA6CgCi-2-wJbl9WzmKKgLMij4N21zB21whX2t5zfA>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3119380079;
        Sun, 23 Jun 2019 16:27:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: ssbd: explicitly depend on <linux/prctl.h>" failed to apply to 4.9-stable tree
To:     aastier@freebox.fr, will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:26:50 +0200
Message-ID: <156132161022460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

