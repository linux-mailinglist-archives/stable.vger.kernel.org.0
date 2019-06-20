Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DDF4D84A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfFTSHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbfFTSHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:07:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED9D2070B;
        Thu, 20 Jun 2019 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054069;
        bh=LreVumlpbITYrk5+jo8LuY8Ek1gDypEGv1kbyWnH9JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCNnRIXsZHyl9qkZyHADfqbal5eP+mpXfFkkj36j16lGnjFeZO0hXz5slKofahf0Q
         hNCdgBnMhMWNXnZKd00lE6KTGgW4fTG2i0REkeyWtY+D2ARoUuzpLLyB7bGlPA985d
         WWKD84AFcvsCz5o2qY3YqjBi1bUOxRXIQ2K91Y/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Landden <shawn@git.icu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 107/117] perf data: Fix strncat may truncate build failure with recent gcc
Date:   Thu, 20 Jun 2019 19:57:21 +0200
Message-Id: <20190620174358.060246844@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 97acec7df172cd1e450f81f5e293c0aa145a2797 ]

This strncat() is safe because the buffer was allocated with zalloc(),
however gcc doesn't know that. Since the string always has 4 non-null
bytes, just use memcpy() here.

    CC       /home/shawn/linux/tools/perf/util/data-convert-bt.o
  In file included from /usr/include/string.h:494,
                   from /home/shawn/linux/tools/lib/traceevent/event-parse.h:27,
                   from util/data-convert-bt.c:22:
  In function ‘strncat’,
      inlined from ‘string_set_value’ at util/data-convert-bt.c:274:4:
  /usr/include/powerpc64le-linux-gnu/bits/string_fortified.h:136:10: error: ‘__builtin_strncat’ output may be truncated copying 4 bytes from a string of length 4 [-Werror=stringop-truncation]
    136 |   return __builtin___strncat_chk (__dest, __src, __len, __bos (__dest));
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shawn Landden <shawn@git.icu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
LPU-Reference: 20190518183238.10954-1-shawn@git.icu
Link: https://lkml.kernel.org/n/tip-289f1jice17ta7tr3tstm9jm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data-convert-bt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 7123f4de32cc..226f4312b8f3 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -265,7 +265,7 @@ static int string_set_value(struct bt_ctf_field *field, const char *string)
 				if (i > 0)
 					strncpy(buffer, string, i);
 			}
-			strncat(buffer + p, numstr, 4);
+			memcpy(buffer + p, numstr, 4);
 			p += 3;
 		}
 	}
-- 
2.20.1



