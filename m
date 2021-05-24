Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B870A38EF0C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhEXPz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235398AbhEXPzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622D96143B;
        Mon, 24 May 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870870;
        bh=5mib4CZtgWgB8CCMyhXcqN7oYJH/iNBMul8UDElOprg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6B7DmZSU1xMbq01m5yTt0Xa3KrCMOBXY4f75VPss8wFIiMUpIGVbi3iADu5hs0ek
         rdsnR69s43p99LkUTndGdHXHzVVjzczcsIbiwn+onUU7oZgvUIXgGNoC8N76pXmdux
         fqfLA+/jc953QtVyw/Rx5WP0PNPSHd95F59Cswb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 072/104] kcsan: Fix debugfs initcall return type
Date:   Mon, 24 May 2021 17:26:07 +0200
Message-Id: <20210524152335.238157502@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 976aac5f882989e4f6c1b3a7224819bf0e801c6a upstream.

clang with CONFIG_LTO_CLANG points out that an initcall function should
return an 'int' due to the changes made to the initcall macros in commit
3578ad11f3fb ("init: lto: fix PREL32 relocations"):

kernel/kcsan/debugfs.c:274:15: error: returning 'void' from a function with incompatible result type 'int'
late_initcall(kcsan_debugfs_init);
~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
include/linux/init.h:292:46: note: expanded from macro 'late_initcall'
 #define late_initcall(fn)               __define_initcall(fn, 7)

Fixes: e36299efe7d7 ("kcsan, debugfs: Move debugfs file creation out of early init")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcsan/debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kcsan/debugfs.c
+++ b/kernel/kcsan/debugfs.c
@@ -261,9 +261,10 @@ static const struct file_operations debu
 	.release = single_release
 };
 
-static void __init kcsan_debugfs_init(void)
+static int __init kcsan_debugfs_init(void)
 {
 	debugfs_create_file("kcsan", 0644, NULL, NULL, &debugfs_ops);
+	return 0;
 }
 
 late_initcall(kcsan_debugfs_init);


