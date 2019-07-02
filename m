Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815095CB4B
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfGBIJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbfGBIJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DEE21841;
        Tue,  2 Jul 2019 08:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054946;
        bh=Gogcx/1vaGK690MCbJwyIJqczVI5Jlg8frPHqYOFL+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOQv3b1ak8JqYzJwuD5ySLbNylA7avLZudWtXMA4b81j+PoAIXaJfmO30pS84WRB7
         OUpqYB+LcapMICp8Y9xeo4mJYCXLnuEd05f8yeZc5y1jBaFcLaBVAx264T9PVLppLW
         jDsggG/PSMHJ8CBF4uPppmcoMSOY9zcZ7EeYervM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 4.14 15/43] Revert "compiler.h: update definition of unreachable()"
Date:   Tue,  2 Jul 2019 10:01:55 +0200
Message-Id: <20190702080124.581588183@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 82017e26e51596ee577171a33f357377ec6513b5, which is
upstream commit fe0640eb30b7da261ae84d252ed9ed3c7e68dfd8.

On Fri, Jun 28, 2019 at 8:53 AM Tony Battersby <tonyb@cybernetics.com> wrote:
>
> Old versions of gcc cannot compile 4.14 since 4.14.113:
>
> ./include/asm-generic/fixmap.h:37: error: implicit declaration of function ‘__builtin_unreachable’
>
> The stable commit that caused the problem is 82017e26e515 ("compiler.h:
> update definition of unreachable()") (upstream commit fe0640eb30b7).
> Reverting the commit fixes the problem.
>
> Kernel 4.17 dropped support for older versions of gcc in upstream commit
> cafa0010cd51 ("Raise the minimum required gcc version to 4.6").  This
> was not backported to 4.14 since that would go against the stable kernel
> rules.
>
> Upstream commit 815f0ddb346c ("include/linux/compiler*.h: make
> compiler-*.h mutually exclusive") was a fix for cafa0010cd51.  This was
> not backported to 4.14.
>
> Upstream commit fe0640eb30b7 ("compiler.h: update definition of
> unreachable()") was a fix for 815f0ddb346c.  This is the commit that was
> backported to 4.14.  But it only fixed a problem introduced in the other
> commits, and without those commits, it ends up introducing a problem
> instead of fixing one.  So I recommend reverting that patch in 4.14,
> which will enable old gcc to compile 4.14 again.  If I understand
> correctly, I believe that clang will still be able to compile 4.14 with
> the patch reverted, although I haven't tried to compile with clang.
>
> The problematic commit is not present in 4.9.x, 4.4.x, 3.18.x, or 3.16.x.

CC: Nick Desaulniers <ndesaulniers@google.com>
CC: Tony Battersby <tonyb@cybernetics.com>,
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 67c3934fb9ed..a704d032713b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -119,10 +119,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 # define ASM_UNREACHABLE
 #endif
 #ifndef unreachable
-# define unreachable() do {		\
-	annotate_unreachable();		\
-	__builtin_unreachable();	\
-} while (0)
+# define unreachable() do { annotate_reachable(); do { } while (1); } while (0)
 #endif
 
 /*
-- 
2.20.1



