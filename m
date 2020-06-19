Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A192012FA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404218AbgFSPTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404091AbgFSPQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9C72080C;
        Fri, 19 Jun 2020 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579793;
        bh=//CgPAApH+7PV0vYRuS2DZn+6GbntVH6DnvobXj342c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRCoIGq40c9FNVuBKABaCDicAUzXm/G+TIjjyRXmKzjhn242qiac6TjG5uydf20Ys
         CQ0oaM/dMwTFsKrIUYu2VeVgOoMF/dDwddt/dIA60lmaeLC/+GAlaUVEhsrs4poYOF
         lpRICclo8uPf08ldo4Qdjq8Bd7KEh1bzoelIevOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.4 261/261] perf symbols: Fix kernel maps for kcore and eBPF
Date:   Fri, 19 Jun 2020 16:34:32 +0200
Message-Id: <20200619141702.397991491@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
@@ -1221,6 +1221,7 @@ int map_groups__merge_in(struct map_grou
 
 				m->end = old_map->start;
 				list_add_tail(&m->node, &merged);
+				new_map->pgoff += old_map->end - new_map->start;
 				new_map->start = old_map->end;
 			}
 		} else {
@@ -1241,6 +1242,7 @@ int map_groups__merge_in(struct map_grou
 				 *      |new......| ->         |new...|
 				 * |old....|        -> |old....|
 				 */
+				new_map->pgoff += old_map->end - new_map->start;
 				new_map->start = old_map->end;
 			}
 		}


