Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7ED3C4930
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbhGLGmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238589AbhGLGlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C8F661132;
        Mon, 12 Jul 2021 06:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071899;
        bh=bLVYdb5/eot21zcHK8AcODvHKYW8MKXwYh3AJjMUh3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIR2ICBInKK9Uprr6S5f9QIVGZFLOBsVVlxzTOSxolINWh31Mx7d+MQdK2nGWCbUw
         upnNtfVPid80WGaMib/IRx1teYjEYlx+kH0swUdGn7a1NeW9vbDE59JJF/l8n5IjNI
         BvmwKYC6Bvr3Xqw2dA57TXbRQkdgwZxtG1g7Vu3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/593] lockdep/selftests: Fix selftests vs PROVE_RAW_LOCK_NESTING
Date:   Mon, 12 Jul 2021 08:07:08 +0200
Message-Id: <20210712060912.977361466@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c0c2c0dad6a06e0c05e9a52d65f932bd54364c97 ]

When PROVE_RAW_LOCK_NESTING=y many of the selftests FAILED because
HARDIRQ context is out-of-bounds for spinlocks. Instead make the
default hardware context the threaded hardirq context, which preserves
the old locking rules.

The wait-type specific locking selftests will have a non-threaded
HARDIRQ variant.

Fixes: de8f5e4f2dc1 ("lockdep: Introduce wait-type checks")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20210617190313.322096283@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/locking-selftest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index a899b3f0e2e5..76c52b0b76d3 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -186,6 +186,7 @@ static void init_shared_classes(void)
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
 	__irq_enter();				\
+	lockdep_hardirq_threaded();		\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\
-- 
2.30.2



