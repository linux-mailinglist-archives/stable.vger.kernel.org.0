Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE65191AA
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfEIS6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbfEISwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44C95217D7;
        Thu,  9 May 2019 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427973;
        bh=0VqV0jJX90eYH8l9rKoIsmKTEX47Oti3YPtNJj6Ig/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPO1gznbFLZg9dNkyFJokq7xinXr5cdFzXX9P+EJ7xnmKdvNt2GKK0PkyEG4PfV1U
         JcjwLbxXrWkMkrEb6Hv+HdDeO9Az3BfkkUFn4DwxNeKKDmxas86cQHQS8CusFeeTtm
         u05a8v0mUkc2Y47430p46U4khQ5zzSEaY7BAzs5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Borislav Petkov <bp@suse.de>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Andrei Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        NeilBrown <neilb@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 38/95] linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()
Date:   Thu,  9 May 2019 20:41:55 +0200
Message-Id: <20190509181311.994204612@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a0fe2c6479aab5723239b315ef1b552673f434a3 ]

Use parentheses around uses of the argument in u64_to_user_ptr() to
ensure that the cast doesn't apply to part of the argument.

There are existing uses of the macro of the form

  u64_to_user_ptr(A + B)

which expands to

  (void __user *)(uintptr_t)A + B

(the cast applies to the first operand of the addition, the addition
is a pointer addition). This happens to still work as intended, the
semantic difference doesn't cause a difference in behavior.

But I want to use u64_to_user_ptr() with a ternary operator in the
argument, like so:

  u64_to_user_ptr(A ? B : C)

This currently doesn't work as intended.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Cc: Andrei Vagin <avagin@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190329214652.258477-1-jannh@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8f0e68e250a76..fd827b2400596 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -73,8 +73,8 @@
 
 #define u64_to_user_ptr(x) (		\
 {					\
-	typecheck(u64, x);		\
-	(void __user *)(uintptr_t)x;	\
+	typecheck(u64, (x));		\
+	(void __user *)(uintptr_t)(x);	\
 }					\
 )
 
-- 
2.20.1



