Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869F12010BE
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391482AbgFSPdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404978AbgFSPdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:33:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C7D020786;
        Fri, 19 Jun 2020 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580790;
        bh=tFY1nRxkJMWURm6HNh899NkO4H1Iow8ETN/RfH323cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3kCbzvCnTKj6sZwXpDGVtxVkP0QjI3tX65JNrjndGDlhvvMv0XaAa9515koZGCcQ
         Bo4MbBN4sih3xxGGHf8SoqS/qzFuNGQF9V3NBncLZT5sKZz4I8gK40oiXqciyjTBKT
         mTUA/qfPlhuyusehsMFyUnQQrtId6afgTKF9N/bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.7 376/376] perf symbols: Fix kernel maps for kcore and eBPF
Date:   Fri, 19 Jun 2020 16:34:54 +0200
Message-Id: <20200619141728.090141991@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 0affd0e5262b6d40f5f63466d88933e99698e240 upstream.

Adjust 'map->pgoff' also when moving a map's start address.

Example with v5.4.34 based kernel:

  Before:

    $ sudo tools/perf/perf record -a --kcore -e intel_pt//k sleep 1
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 1.958 MB perf.data ]
    $ sudo tools/perf/perf script --itrace=e >/dev/null
    Warning:
    961 instruction trace errors

  After:

    $ sudo tools/perf/perf script --itrace=e >/dev/null
    $

Committer testing:

  # uname -a
  Linux seventh 5.6.10-100.fc30.x86_64 #1 SMP Mon May 4 15:36:44 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
  #

Before:

  # perf record -a --kcore -e intel_pt//k sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.923 MB perf.data ]
  # perf script --itrace=e >/dev/null
  Warning:
  295 instruction trace errors
  #

After:

  # perf record -a --kcore -e intel_pt//k sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.919 MB perf.data ]
  # perf script --itrace=e >/dev/null
  #

Fixes: fb5a88d4131a ("perf tools: Preserve eBPF maps when loading kcore")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200602112505.1406-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/symbol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1210,6 +1210,7 @@ int maps__merge_in(struct maps *kmaps, s
 
 				m->end = old_map->start;
 				list_add_tail(&m->node, &merged);
+				new_map->pgoff += old_map->end - new_map->start;
 				new_map->start = old_map->end;
 			}
 		} else {
@@ -1230,6 +1231,7 @@ int maps__merge_in(struct maps *kmaps, s
 				 *      |new......| ->         |new...|
 				 * |old....|        -> |old....|
 				 */
+				new_map->pgoff += old_map->end - new_map->start;
 				new_map->start = old_map->end;
 			}
 		}


