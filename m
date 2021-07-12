Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB73C52B0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbhGLHsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346683AbhGLHql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97AF661183;
        Mon, 12 Jul 2021 07:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075736;
        bh=khWwxZN4Q9keLfsKl4AnOJt4up4F52KZlZIRb/onXjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DI8RhYPCB5NA5xXUjOgnDnK/hOtJvFoyZXIoRDX/+zHx9YRIUi20fQkJznZIYc32F
         998uJtaEfCyRq8happ4ekOMBYlOThfOSiVOnjB44OGAol90vcC7UQsb5IbIAhjekNB
         joZPbVjNrENzXrVh/VXwl7aG8rf1cg+P5eJmCARw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 343/800] lockdep/selftests: Fix selftests vs PROVE_RAW_LOCK_NESTING
Date:   Mon, 12 Jul 2021 08:06:06 +0200
Message-Id: <20210712061003.385713224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 2d85abac1744..0f6b262e0964 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -194,6 +194,7 @@ static void init_shared_classes(void)
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
 	__irq_enter();				\
+	lockdep_hardirq_threaded();		\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\
-- 
2.30.2



