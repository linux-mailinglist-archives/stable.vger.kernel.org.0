Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C9318B6E1
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgCSNXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbgCSNXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F48208D6;
        Thu, 19 Mar 2020 13:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624223;
        bh=GK0txNaAhC1Tj3gLksvBxH5YZiIIZrSnVTFV8FXTM/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwU7spysZLjKfViTCw5D7/doukysHO+JKQvfs8D9fYHpQ7B0/P0Y4btovPbgbjgnz
         G+cVsZrLPzbUmgXxSqqmiuFPc7EWACSRG/FBF7YhKqwCXkT/hqgMFF5SfZZnPSkmFl
         QVlg79STLzN9T+ZBez1fwLhDLPu+Jzk2PnaE2NRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/60] selftests/rseq: Fix out-of-tree compilation
Date:   Thu, 19 Mar 2020 14:03:59 +0100
Message-Id: <20200319123925.958814970@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ef89d0545132d685f73da6f58b7e7fe002536f91 ]

Currently if you build with O=... the rseq tests don't build:

  $ make O=$PWD/output -C tools/testing/selftests/ TARGETS=rseq
  make: Entering directory '/linux/tools/testing/selftests'
  ...
  make[1]: Entering directory '/linux/tools/testing/selftests/rseq'
  gcc -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./  -shared -fPIC rseq.c -lpthread -o /linux/output/rseq/librseq.so
  gcc -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./  basic_test.c -lpthread -lrseq -o /linux/output/rseq/basic_test
  /usr/bin/ld: cannot find -lrseq
  collect2: error: ld returned 1 exit status

This is because the library search path points to the source
directory, not the output.

We can fix it by changing the library search path to $(OUTPUT).

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rseq/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index f1053630bb6f5..2af9d39a97168 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -4,7 +4,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
 CLANG_FLAGS += -no-integrated-as
 endif
 
-CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./ \
+CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L$(OUTPUT) -Wl,-rpath=./ \
 	  $(CLANG_FLAGS)
 LDLIBS += -lpthread
 
-- 
2.20.1



