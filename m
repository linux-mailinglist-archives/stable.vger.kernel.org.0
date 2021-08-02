Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54A3DD8BD
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhHBNzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235278AbhHBNwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8E56112D;
        Mon,  2 Aug 2021 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912304;
        bh=G60XXbGHGwAvo+h6LyXRz0eBUCVpr7FmTdq4fUQKEgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BX7I5fNaFl71fvboSrqPh9GJVx4gT1CbuEg16zVzhXWDLsMZsbXhYMY6LBTOq3KSt
         0uYu+mhO7SWCLTbiix31rYowWJKHHg0FnmefOTbtXxLS1971CPPEa7DRceDMCEGbgm
         5OX4CP8shEec7WjctAojxhOkNBYITXXkCBkbxaLM=
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
Subject: [PATCH 5.4 38/40] Revert "perf map: Fix dso->nsinfo refcounting"
Date:   Mon,  2 Aug 2021 15:45:18 +0200
Message-Id: <20210802134336.612232344@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
@@ -214,8 +214,6 @@ struct map *map__new(struct machine *mac
 			if (!(prot & PROT_EXEC))
 				dso__set_loaded(dso);
 		}
-
-		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
 		dso__put(dso);
 	}


