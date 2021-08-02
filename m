Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16653DD855
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhHBNvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234628AbhHBNuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB57460527;
        Mon,  2 Aug 2021 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912215;
        bh=fp66PKMkZv7SjqD3Wg879LDEq12HBvW62IGsBxIa7Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEzsPEoaOWG3uOv+yQG8JDqFQyl3suYysobKj1ZiFuzltKlAocpHjFyUfCbSi61zE
         GYhf2X2wDi8H4Ek272al9ppFs0x3Sl7D7Ucx9bK+Zid7ApoHLs5MJBquEYza6gbQE8
         gjqGsfIOCbXPsgbJkrZtOSBq+3Envp3HMfYgqkPU=
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
Subject: [PATCH 4.19 29/30] Revert "perf map: Fix dso->nsinfo refcounting"
Date:   Mon,  2 Aug 2021 15:45:07 +0200
Message-Id: <20210802134335.022545989@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
References: <20210802134334.081433902@linuxfoundation.org>
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
@@ -209,8 +209,6 @@ struct map *map__new(struct machine *mac
 			if (!(prot & PROT_EXEC))
 				dso__set_loaded(dso);
 		}
-
-		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
 		dso__put(dso);
 	}


