Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596B7167516
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388419AbgBUIXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388417AbgBUIXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:23:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C9E92467A;
        Fri, 21 Feb 2020 08:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273385;
        bh=vz5gTBeqfS9iKhsuyNNi+PbAPPat9tNnC+F6SHigKak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR8m9N1S1SuOINum0ywTBy/D1VKSvsaJmxRWB26UCaeDamHDGUmqr9BznWkm/CBAu
         jhhRNju3O5NeClY4DTXRQXbjMnXUE4tVnfiIVgSpPIB+RpQmJQvCcbIcLQBflfPhBz
         javFmg+4BYBUo9z3pO7xtK7J4Dcest3w4Nv09S6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/191] kbuild: use -S instead of -E for precise cc-option test in Kconfig
Date:   Fri, 21 Feb 2020 08:42:04 +0100
Message-Id: <20200221072308.858375369@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3bed1b7b9d79ca40e41e3af130931a3225e951a3 ]

Currently, -E (stop after the preprocessing stage) is used to check
whether the given compiler flag is supported.

While it is faster than -S (or -c), it can be false-positive. You need
to run the compilation proper to check the flag more precisely.

For example, -E and -S disagree about the support of
"--param asan-instrument-allocas=1".

$ gcc -Werror --param asan-instrument-allocas=1 -E -x c /dev/null -o /dev/null
$ echo $?
0

$ gcc -Werror --param asan-instrument-allocas=1 -S -x c /dev/null -o /dev/null
cc1: error: invalid --param name ‘asan-instrument-allocas’; did you mean ‘asan-instrument-writes’?
$ echo $?
1

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kconfig.include | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index 3b2861f47709b..79455ad6b3863 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -20,7 +20,7 @@ success = $(if-success,$(1),y,n)
 
 # $(cc-option,<flag>)
 # Return y if the compiler supports <flag>, n otherwise
-cc-option = $(success,$(CC) -Werror $(CLANG_FLAGS) $(1) -E -x c /dev/null -o /dev/null)
+cc-option = $(success,$(CC) -Werror $(CLANG_FLAGS) $(1) -S -x c /dev/null -o /dev/null)
 
 # $(ld-option,<flag>)
 # Return y if the linker supports <flag>, n otherwise
-- 
2.20.1



