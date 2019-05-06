Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9ED14E0E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfEFO6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbfEFOnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EADF2053B;
        Mon,  6 May 2019 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153831;
        bh=4xYcLi0v/90g60aYbXadPiz+Amu7KqdU99q7SC1Cxl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UU9tnve7tTnDWVa4fU3NNQCnkLufrFWzRQt8vpf4TdgY1HXPxAxm16gEM4OkF+Vvm
         +LNp9Ir5Y3e9Y7FcjsUVyrkUIpN+v9gNSBvHjGi7RpffW8VyEnvkOuWnGL/op2DtkD
         LWTL5uhD2pJtSV5hS8v2dPsE9rUBzi/cuf6dGvss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nick Terrell <terrelln@fb.com>, Chris Mason <clm@fb.com>,
        Yury Norov <ynorov@caviumnetworks.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeff Layton <jlayton@redhat.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Kostya Serebryany <kcc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 13/75] kasan: prevent compiler from optimizing away memset in tests
Date:   Mon,  6 May 2019 16:32:21 +0200
Message-Id: <20190506143054.399239912@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit 69ca372c100fba99c78ef826a1795aa86e4f01a8 upstream.

A compiler can optimize away memset calls by replacing them with mov
instructions.  There are KASAN tests that specifically test that KASAN
correctly handles memset calls so we don't want this optimization to
happen.

The solution is to add -fno-builtin flag to test_kasan.ko

Link: http://lkml.kernel.org/r/105ec9a308b2abedb1a0d1fdced0c22d765e4732.1519924383.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Chris Mason <clm@fb.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Kostya Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_TEST_FIRMWARE) += test_firm
 obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
+CFLAGS_test_kasan.o += -fno-builtin
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_TEST_LKM) += test_module.o


