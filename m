Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492183DD933
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhHBN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235899AbhHBN4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:56:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C646113C;
        Mon,  2 Aug 2021 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912467;
        bh=ZUipM+grXA9HlVDMC3KEq/8VnFrZShP7/ttL4DzRZfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCUMGnRjhvxC6wLkHy/CeUUp5U4l4ffR86OGgS5ENED3OrIzyNhn6gfbMcT2xoReP
         1kkv2EWOtnQkGwhd4ohXPGp+LwpM/lm1ZQWpkc6cmX8r7GjirIq8qFmmMfUrsffeeX
         uuGzqf8Gtgdwj0iMuntTGXrW1vTIZy0d02HroCtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Krister Johansen <kjlx@templeofstupid.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 65/67] Revert "perf map: Fix dso->nsinfo refcounting"
Date:   Mon,  2 Aug 2021 15:45:28 +0200
Message-Id: <20210802134341.268764886@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 9bac1bd6e6d36459087a728a968e79e37ebcea1a upstream.

This makes 'perf top' abort in some cases, and the right fix will
involve surgery that is too much to do at this stage, so revert for now
and fix it in the next merge window.

This reverts commit 2d6b74baa7147251c30a46c4996e8cc224aa2dc5.

Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Krister Johansen <kjlx@templeofstupid.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/map.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -192,8 +192,6 @@ struct map *map__new(struct machine *mac
 			if (!(prot & PROT_EXEC))
 				dso__set_loaded(dso);
 		}
-
-		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
 		dso__put(dso);
 	}


