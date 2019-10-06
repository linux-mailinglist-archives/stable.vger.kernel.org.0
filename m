Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DFCCD76D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfJFR2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbfJFR2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:28:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 495F921479;
        Sun,  6 Oct 2019 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382932;
        bh=5gqlC+gB7sVHqAORGtvXGvqdowvWZMUU+1LOeJQXM+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utJplJdxLvU6/XUo052W8l8cTkWXsly9iKEFSzOTI90G1J5QzB54hO5NEWeDxPTjA
         Fc9r1Kp4i6XDmUy0Yf4VFKU7p3hlB3nGg3pK33Sqy6GH7sauouhy53nmSdVg27z4Rb
         TvaCureldOaacXa+F3B9di8/EdRQqqFdxNbQkAjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/106] powerpc/futex: Fix warning: oldval may be used uninitialized in this function
Date:   Sun,  6 Oct 2019 19:20:30 +0200
Message-Id: <20191006171137.038141022@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



