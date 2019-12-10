Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD65811972B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfLJVJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbfLJVJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6F9246B4;
        Tue, 10 Dec 2019 21:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012160;
        bh=ExJa1uzw4YsyFUsIJI3vUUtRkYWOhea+6RzTG0beOdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jF6NNBn4OL3L6PQzPZfPPeiR/Pgv5/7jqJvlgokoIULJhQGFaNE5rXDvJ/3/WKM/
         7XigXE06yimGUYHuZsRvAJxZPgXehGtnNCFMTyxRas2zLqoVPkQiHJ32ikM+RfukBt
         Bun9OH9RB9zI9lTJnaJS21+6Sue7aUnPdK3qokRk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Tim Bird <Tim.Bird@sony.com>, Tim Bird <tim.bird@sony.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 122/350] selftests: Fix O= and KBUILD_OUTPUT handling for relative paths
Date:   Tue, 10 Dec 2019 16:03:47 -0500
Message-Id: <20191210210735.9077-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 303e6218ecec475d5bc3e5922dec770ee5baf107 ]

Fix O= and KBUILD_OUTPUT handling for relative paths.

export KBUILD_OUTPUT=../kselftest_size
make TARGETS=size kselftest-all

or

make O=../kselftest_size TARGETS=size kselftest-all

In both of these cases, targets get built in ../kselftest_size which is
a one level up from the size test directory.

make[1]: Entering directory '/mnt/data/lkml/kselftest_size'
make --no-builtin-rules INSTALL_HDR_PATH=$BUILD/usr \
        ARCH=x86 -C ../../.. headers_install
  INSTALL ../kselftest_size/usr/include
gcc -static -ffreestanding -nostartfiles -s    get_size.c  -o ../kselftest_size/size/get_size
/usr/bin/ld: cannot open output file ../kselftest_size/size/get_size: No such file or directory
collect2: error: ld returned 1 exit status
make[3]: *** [../lib.mk:138: ../kselftest_size/size/get_size] Error 1
make[2]: *** [Makefile:143: all] Error 2
make[1]: *** [/mnt/data/lkml/linux_5.4/Makefile:1221: kselftest-all] Error 2
make[1]: Leaving directory '/mnt/data/lkml/kselftest_size'
make: *** [Makefile:179: sub-make] Error 2

Use abs_objtree exported by the main Makefile.

Reported-by: Tim Bird <Tim.Bird@sony.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Tested-by: Tim Bird <tim.bird@sony.com>
Acked-by: Tim Bird <tim.bird@sony.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4cdbae6f4e61b..3405aa26a655a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -86,10 +86,10 @@ override LDFLAGS =
 endif
 
 ifneq ($(O),)
-	BUILD := $(O)
+	BUILD := $(abs_objtree)
 else
 	ifneq ($(KBUILD_OUTPUT),)
-		BUILD := $(KBUILD_OUTPUT)/kselftest
+		BUILD := $(abs_objtree)/kselftest
 	else
 		BUILD := $(shell pwd)
 		DEFAULT_INSTALL_HDR_PATH := 1
@@ -102,6 +102,7 @@ include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
 export BUILD
+#$(info abd_objtree = $(abs_objtree) BUILD = $(BUILD))
 
 # build and run gpio when output directory is the src dir.
 # gpio has dependency on tools/gpio and builds tools/gpio
-- 
2.20.1

