Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E203DDA02
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhHBOF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236969AbhHBOE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5426761222;
        Mon,  2 Aug 2021 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912670;
        bh=X64YkVdn1231s65d04COEk+rX2/Ne4ry9Ms686Hv+XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LeXg5KtI5Xvn1uXxMEJxekEmGKdnPEHyryF0AxS4qpktBSGObTvpBOZ9k56K0prt
         bIl6tKMILe0lSPMzpTu5+KvTCVgqafM9YEb3aPuzY7IF5SSUKYL/I3u/CuGyCDLPHJ
         AfZ4BXrfS3/t3taPWztjVlUXffBa0GbDGc5J1HXA=
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
Subject: [PATCH 5.13 099/104] Revert "perf map: Fix dso->nsinfo refcounting"
Date:   Mon,  2 Aug 2021 15:45:36 +0200
Message-Id: <20210802134347.264291111@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
 
 		if (build_id__is_defined(bid))


