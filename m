Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9F53D6032
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhGZPVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237139AbhGZPVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA8060F5A;
        Mon, 26 Jul 2021 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315302;
        bh=jnwL9oSy03Knv9wzFjNz98XWr/TQv4RU3bqPVP0kbDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4L535jzI+TymcVxFe/kgf9689Pz2/SReOfOYH9c6QXQIyU7PD7pcIO6tTVXrgd0X
         s9lEhGNBDFsc6MLwPOAEfkb1f2RvafKOv37pibPa552LTBxGzH8xSzYbN6mWDagXQu
         whSuc2EObDn+07GEq0Be/f6aivMuGMWS0D0FER80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/167] perf lzma: Close lzma stream on exit
Date:   Mon, 26 Jul 2021 17:37:57 +0200
Message-Id: <20210726153840.870236735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit f8cbb0f926ae1e1fb5f9e51614e5437560ed4039 ]

ASan reports memory leaks when running:

  # perf test "88: Check open filename arg using perf trace + vfs_getname"

One of these is caused by the lzma stream never being closed inside
lzma_decompress_to_file().

This patch adds the missing lzma_end().

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 80a32e5b498a7547 ("perf tools: Add lzma decompression support for kernel module")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/aaf50bdce7afe996cfc06e1bbb36e4a2a9b9db93.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/lzma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/lzma.c b/tools/perf/util/lzma.c
index 39062df02629..51424cdc3b68 100644
--- a/tools/perf/util/lzma.c
+++ b/tools/perf/util/lzma.c
@@ -69,7 +69,7 @@ int lzma_decompress_to_file(const char *input, int output_fd)
 
 			if (ferror(infile)) {
 				pr_err("lzma: read error: %s\n", strerror(errno));
-				goto err_fclose;
+				goto err_lzma_end;
 			}
 
 			if (feof(infile))
@@ -83,7 +83,7 @@ int lzma_decompress_to_file(const char *input, int output_fd)
 
 			if (writen(output_fd, buf_out, write_size) != write_size) {
 				pr_err("lzma: write error: %s\n", strerror(errno));
-				goto err_fclose;
+				goto err_lzma_end;
 			}
 
 			strm.next_out  = buf_out;
@@ -95,11 +95,13 @@ int lzma_decompress_to_file(const char *input, int output_fd)
 				break;
 
 			pr_err("lzma: failed %s\n", lzma_strerror(ret));
-			goto err_fclose;
+			goto err_lzma_end;
 		}
 	}
 
 	err = 0;
+err_lzma_end:
+	lzma_end(&strm);
 err_fclose:
 	fclose(infile);
 	return err;
-- 
2.30.2



