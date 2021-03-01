Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E58328AFC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhCAS0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239044AbhCASUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7090651F1;
        Mon,  1 Mar 2021 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619194;
        bh=7mrbYD9fUMsQfvKKK4kV7DA+2663XW+BrNWqORLfTUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4adSLHnHsV0byV23+VgAR4YExn8/lFjXAWe7e/s2hEtBLqpk/yrrji42bCa9hURb
         BJWEB1y8h2UzwmFc3sVFDWFg8hBGxcxEhCliLAEiKQ3LLNC7i3vUoiFrSbNdXLIRUw
         SpCaRlG0flgFwp3SnmroToaAr95MhFo6YbbNyheY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Safonov <dima@arista.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Jacek Caban <jacek@codeweavers.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Remi Bernon <rbernon@codeweavers.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/663] perf symbols: Use (long) for iterator for bfd symbols
Date:   Mon,  1 Mar 2021 17:10:15 +0100
Message-Id: <20210301161200.002005524@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit 96de68fff5ded8833bf5832658cb43c54f86ff6c ]

GCC (GCC) 8.4.0 20200304 fails to build perf with:
: util/symbol.c: In function 'dso__load_bfd_symbols':
: util/symbol.c:1626:16: error: comparison of integer expressions of different signednes
:   for (i = 0; i < symbols_count; ++i) {
:                 ^
: util/symbol.c:1632:16: error: comparison of integer expressions of different signednes
:    while (i + 1 < symbols_count &&
:                 ^
: util/symbol.c:1637:13: error: comparison of integer expressions of different signednes
:    if (i + 1 < symbols_count &&
:              ^
: cc1: all warnings being treated as errors

It's unlikely that the symtable will be that big, but the fix is an
oneliner and as perf has CORE_CFLAGS += -Wextra, which makes build to
fail together with CORE_CFLAGS += -Werror

Fixes: eac9a4342e54 ("perf symbols: Try reading the symbol table with libbfd")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Jacek Caban <jacek@codeweavers.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Remi Bernon <rbernon@codeweavers.com>
Link: http://lore.kernel.org/lkml/20210209145148.178702-1-dima@arista.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0d14abdf3d722..da6036ba0cea4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1561,12 +1561,11 @@ static int bfd2elf_binding(asymbol *symbol)
 int dso__load_bfd_symbols(struct dso *dso, const char *debugfile)
 {
 	int err = -1;
-	long symbols_size, symbols_count;
+	long symbols_size, symbols_count, i;
 	asection *section;
 	asymbol **symbols, *sym;
 	struct symbol *symbol;
 	bfd *abfd;
-	u_int i;
 	u64 start, len;
 
 	abfd = bfd_openr(dso->long_name, NULL);
-- 
2.27.0



