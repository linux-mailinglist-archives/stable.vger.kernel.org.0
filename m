Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E780D177F2E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgCCRtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730830AbgCCRtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138E1208C3;
        Tue,  3 Mar 2020 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257747;
        bh=2iJwWasVf+CDL+1GCCg+dC8safmJqLUpKJYeW7tEWz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZslrvy0Ba4gQV2SbhU4DRKilc+eQqDArk8aqPVs5+6wI4UFKWsfcmpoBjbO7kknX
         flXF+RX4z6qiYsa3oA4JoR4PPaRFHwhNxP77VQhHOR+6VNtB+n2uiFWejSsg70lXRD
         XhthIfxzzuiOPUmsKWhYx2VumXf3WQJ1YilkmOjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Paul Burton <paulburton@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.5 114/176] MIPS: cavium_octeon: Fix syncw generation.
Date:   Tue,  3 Mar 2020 18:42:58 +0100
Message-Id: <20200303174318.020233777@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit 97e914b7de3c943011779b979b8093fdc0d85722 upstream.

The Cavium Octeon CPU uses a special sync instruction for implementing
wmb, and due to a CPU bug, the instruction must appear twice. A macro
had been defined to hide this:

 #define __SYNC_rpt(type)     (1 + (type == __SYNC_wmb))

which was intended to evaluate to 2 for __SYNC_wmb, and 1 for any other
type of sync. However, this expression is evaluated by the assembler,
and not the compiler, and the result of '==' in the assembler is 0 or
-1, not 0 or 1 as it is in C. The net result was wmb() producing no code
at all. The simple fix in this patch is to change the '+' to '-'.

Fixes: bf92927251b3 ("MIPS: barrier: Add __SYNC() infrastructure")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/sync.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/sync.h
+++ b/arch/mips/include/asm/sync.h
@@ -155,9 +155,11 @@
  * effective barrier as noted by commit 6b07d38aaa52 ("MIPS: Octeon: Use
  * optimized memory barrier primitives."). Here we specify that the affected
  * sync instructions should be emitted twice.
+ * Note that this expression is evaluated by the assembler (not the compiler),
+ * and that the assembler evaluates '==' as 0 or -1, not 0 or 1.
  */
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
-# define __SYNC_rpt(type)	(1 + (type == __SYNC_wmb))
+# define __SYNC_rpt(type)	(1 - (type == __SYNC_wmb))
 #else
 # define __SYNC_rpt(type)	1
 #endif


