Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B264638EF85
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhEXP6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234692AbhEXP45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C1B16194A;
        Mon, 24 May 2021 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870998;
        bh=xOEGtQeJhtNmNQm5H4zbZfcB6iaCDO89XW8LkWe25LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW5TIHNy6ExaVor6oiVzyX/tZlzLiEsgJsrmDLcZbqGcUaj/+bcJ7QMoJhRNi53JJ
         ow3eg8YMMZptnlpGYlwIX6x+85XI8tAMEfYCMgbqpiigrEsdVrmJQKhyEFmvrPzvnP
         CZQS8kbQlxSfHu+jy4wXGSJXBjV/mDxXNIpPUTz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Chris Kennelly <ckennelly@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 026/127] tools/testing/selftests/exec: fix link error
Date:   Mon, 24 May 2021 17:25:43 +0200
Message-Id: <20210524152335.732117847@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4d1cd3b2c5c1c32826454de3a18c6183238d47ed ]

Fix the link error by adding '-static':

  gcc -Wall  -Wl,-z,max-page-size=0x1000 -pie load_address.c -o /home/yang/linux/tools/testing/selftests/exec/load_address_4096
  /usr/bin/ld: /tmp/ccopEGun.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `stderr@@GLIBC_2.17' which may bind externally can not be used when making a shared object; recompile with -fPIC
  /usr/bin/ld: /tmp/ccopEGun.o(.text+0x158): unresolvable R_AARCH64_ADR_PREL_PG_HI21 relocation against symbol `stderr@@GLIBC_2.17'
  /usr/bin/ld: final link failed: bad value
  collect2: error: ld returned 1 exit status
  make: *** [Makefile:25: tools/testing/selftests/exec/load_address_4096] Error 1

Link: https://lkml.kernel.org/r/20210514092422.2367367-1-yangyingliang@huawei.com
Fixes: 206e22f01941 ("tools/testing/selftests: add self-test for verifying load alignment")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Chris Kennelly <ckennelly@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/exec/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index cf69b2fcce59..dd61118df66e 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -28,8 +28,8 @@ $(OUTPUT)/execveat.denatured: $(OUTPUT)/execveat
 	cp $< $@
 	chmod -x $@
 $(OUTPUT)/load_address_4096: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie -static $< -o $@
 $(OUTPUT)/load_address_2097152: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie -static $< -o $@
 $(OUTPUT)/load_address_16777216: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie -static $< -o $@
-- 
2.30.2



