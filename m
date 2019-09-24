Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C26BCF88
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405856AbfIXQ6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389126AbfIXQth (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D48B222BF;
        Tue, 24 Sep 2019 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343776;
        bh=5gqlC+gB7sVHqAORGtvXGvqdowvWZMUU+1LOeJQXM+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHVVmugj4QRJtbPSg9ayHhFtt3mOfet6JfxFjz/XhicgmAhStR8z8LEPBe9aADgmd
         92JYVvfitb50X1UYJRWd/+Ao8be/t5yaX4sSCuG4uUw+6CgyqyGfTyVr2a5onoMv/8
         aMrhg2ivvt7KfIN6k3MKVjZ7cWJU2DUxGEG/a/FE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 25/50] powerpc/futex: Fix warning: 'oldval' may be used uninitialized in this function
Date:   Tue, 24 Sep 2019 12:48:22 -0400
Message-Id: <20190924164847.27780-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 38a0d0cdb46d3f91534e5b9839ec2d67be14c59d ]

We see warnings such as:
  kernel/futex.c: In function 'do_futex':
  kernel/futex.c:1676:17: warning: 'oldval' may be used uninitialized in this function [-Wmaybe-uninitialized]
     return oldval == cmparg;
                   ^
  kernel/futex.c:1651:6: note: 'oldval' was declared here
    int oldval, ret;
        ^

This is because arch_futex_atomic_op_inuser() only sets *oval if ret
is 0 and GCC doesn't see that it will only use it when ret is 0.

Anyway, the non-zero ret path is an error path that won't suffer from
setting *oval, and as *oval is a local var in futex_atomic_op_inuser()
it will have no impact.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[mpe: reword change log slightly]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/86b72f0c134367b214910b27b9a6dd3321af93bb.1565774657.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/futex.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
index 94542776a62d6..2a7b01f97a56b 100644
--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -59,8 +59,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 
 	pagefault_enable();
 
-	if (!ret)
-		*oval = oldval;
+	*oval = oldval;
 
 	return ret;
 }
-- 
2.20.1

