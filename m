Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581CE3D6170
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhGZPbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237896AbhGZP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5447160F92;
        Mon, 26 Jul 2021 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315781;
        bh=1/SqaE4eDei7KFRnBV7204TY+WYY4kxgSfQTiG6S3hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqpQnCH9onB01FQdZoR/qmmiXfRVOkdWlKOF4uljrmfla/WsKR6+TsmKP9fIHRTBp
         5H5+PFHUqV/zd41hTWoh0QR8spi4GHa7WYMpliSvR9boyT2NplLHbnGWanmu/q5B1P
         gOkidwllHmhp2QElZKpptsvZ8gWgvdgfy9jz+3Ds=
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
Subject: [PATCH 5.13 063/223] perf probe-file: Delete namelist in del_events() on the error path
Date:   Mon, 26 Jul 2021 17:37:35 +0200
Message-Id: <20210726153848.325155553@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit e0fa7ab42232e742dcb3de9f3c1f6127b5adc019 ]

ASan reports some memory leaks when running:

  # perf test "42: BPF filter"

This second leak is caused by a strlist not being dellocated on error
inside probe_file__del_events.

This patch adds a goto label before the deallocation and makes the error
path jump to it.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: e7895e422e4da63d ("perf probe: Split del_perf_probe_events()")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/174963c587ae77fa108af794669998e4ae558338.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 52273542e6ef..3f6de459ac2b 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -342,11 +342,11 @@ int probe_file__del_events(int fd, struct strfilter *filter)
 
 	ret = probe_file__get_events(fd, filter, namelist);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = probe_file__del_strlist(fd, namelist);
+out:
 	strlist__delete(namelist);
-
 	return ret;
 }
 
-- 
2.30.2



