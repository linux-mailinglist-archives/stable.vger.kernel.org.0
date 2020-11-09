Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E85E2AB9AD
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731543AbgKINLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:11:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731757AbgKINL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:11:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8937F2076E;
        Mon,  9 Nov 2020 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927487;
        bh=H64nzRCPW422wYyOo1zSeWbPHtd0/Fy7QeE82Wz53Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWTe2sEIWCFl88iAUkivit6q9xAuVG3z9XsSkfpychUhk8mDnuPBqx84ygtq3Z8iw
         RaKSTE77cBHKx/nOzwd6jnLGxxDCdnEkswNPvXrhTExMfyvw2SdzjyG1xkBGBgBXtO
         T3fh8gzJf1bk7ubHfkxXu9A3s8uzIIpqyjRRntdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 69/71] tools: perf: Fix build error in v4.19.y
Date:   Mon,  9 Nov 2020 13:56:03 +0100
Message-Id: <20201109125023.136764212@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

perf may fail to build in v4.19.y with the following error.

util/evsel.c: In function ‘perf_evsel__exit’:
util/util.h:25:28: error:
	passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type

This is observed (at least) with gcc v6.5.0. The underlying problem is
the following statement.
	zfree(&evsel->pmu_name);
evsel->pmu_name is decared 'const *'. zfree in turn is defined as
	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
and thus passes the const * to free(). The problem is not seen
in the upstream kernel since zfree() has been rewritten there.

The problem has been introduced into v4.19.y with the backport of upstream
commit d4953f7ef1a2 (perf parse-events: Fix 3 use after frees found with
clang ASAN).

One possible fix of this problem would be to not declare pmu_name
as const. This patch chooses to typecast the parameter of zfree()
to void *, following the guidance from the upstream kernel which
does the same since commit 7f7c536f23e6a ("tools lib: Adopt
zalloc()/zfree() from tools/perf")

Fixes: a0100a363098 ("perf parse-events: Fix 3 use after frees found with clang ASAN")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This patch only applies to v4.19.y and has no upstream equivalent.

 tools/perf/util/util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -22,7 +22,7 @@ static inline void *zalloc(size_t size)
 	return calloc(1, size);
 }
 
-#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
+#define zfree(ptr) ({ free((void *)*ptr); *ptr = NULL; })
 
 struct dirent;
 struct nsinfo;


