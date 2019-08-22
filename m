Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDDE99B14
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbfHVRTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390295AbfHVRIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:24 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EACED23404;
        Thu, 22 Aug 2019 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493703;
        bh=WozQVHAvxMlGUO9JWvfxjwZ3Pv3TpGs1akcR2dUpekk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EplEx8lIhIcIAgHB30E+zWUQ6Tn9jgJ10upY0z4NYjywy5+V7CTHAjHs1vl2nzARX
         MZJMthCeWNMEZ73B1fSRwlgkcmaWfuuiD16jpyFOPvljvmMx6GN/Ex+tQRjTAQKpdy
         BZkmU8ZPkob9+cFn1gsyUwxwWY+UPRnxXqswkb5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 015/135] xtensa: add missing isync to the cpu_reset TLB code
Date:   Thu, 22 Aug 2019 13:06:11 -0400
Message-Id: <20190822170811.13303-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit cd8869f4cb257f22b89495ca40f5281e58ba359c upstream.

ITLB entry modifications must be followed by the isync instruction
before the new entries are possibly used. cpu_reset lacks one isync
between ITLB way 6 initialization and jump to the identity mapping.
Add missing isync to xtensa cpu_reset.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 176cb46bcf12c..0634bfb82a0bc 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -515,6 +515,7 @@ void cpu_reset(void)
 				      "add	%2, %2, %7\n\t"
 				      "addi	%0, %0, -1\n\t"
 				      "bnez	%0, 1b\n\t"
+				      "isync\n\t"
 				      /* Jump to identity mapping */
 				      "jx	%3\n"
 				      "2:\n\t"
-- 
2.20.1

