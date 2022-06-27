Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3EC55C785
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbiF0Lni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbiF0Lmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE07E6B;
        Mon, 27 Jun 2022 04:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC35B8111B;
        Mon, 27 Jun 2022 11:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66189C3411D;
        Mon, 27 Jun 2022 11:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329835;
        bh=A5UBWaCrl/qkluSIKGtZTc8F6JYpzds5b08cBXNIoF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaaXK+5N0qe9mdMR3BvbYcVSHxWYEd3JxLe19LL40Ge2v6zT6XPyECMMneIMJujp8
         xFxsQj4z71Zuw3bh2SDZDEPBtOAWB7pEgSOJE+RGPuf7BEY4YNogx3Uc2ekiFJ/GYc
         SEaTVeqi2wXvZZHFql84R/lXn8MqD3ydtS6BfQLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 132/135] perf build-id: Fix caching files with a wrong build ID
Date:   Mon, 27 Jun 2022 13:22:19 +0200
Message-Id: <20220627111941.981608747@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit ab66fdace8581ef3b4e7cf5381a168ed4058d779 upstream.

Build ID events associate a file name with a build ID.  However, when
using perf inject, there is no guarantee that the file on the current
machine at the current time has that build ID. Fix by comparing the
build IDs and skip adding to the cache if they are different.

Example:

  $ echo "int main() {return 0;}" > prog.c
  $ gcc -o prog prog.c
  $ perf record --buildid-all ./prog
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.019 MB perf.data ]
  $ file-buildid() { file $1 | awk -F= '{print $2}' | awk -F, '{print $1}' ; }
  $ file-buildid prog
  444ad9be165d8058a48ce2ffb4e9f55854a3293e
  $ file-buildid ~/.debug/$(pwd)/prog/444ad9be165d8058a48ce2ffb4e9f55854a3293e/elf
  444ad9be165d8058a48ce2ffb4e9f55854a3293e
  $ echo "int main() {return 1;}" > prog.c
  $ gcc -o prog prog.c
  $ file-buildid prog
  885524d5aaa24008a3e2b06caa3ea95d013c0fc5

Before:

  $ perf buildid-cache --purge $(pwd)/prog
  $ perf inject -i perf.data -o junk
  $ file-buildid ~/.debug/$(pwd)/prog/444ad9be165d8058a48ce2ffb4e9f55854a3293e/elf
  885524d5aaa24008a3e2b06caa3ea95d013c0fc5
  $

After:

  $ perf buildid-cache --purge $(pwd)/prog
  $ perf inject -i perf.data -o junk
  $ file-buildid ~/.debug/$(pwd)/prog/444ad9be165d8058a48ce2ffb4e9f55854a3293e/elf

  $

Fixes: 454c407ec17a0c63 ("perf: add perf-inject builtin")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: https://lore.kernel.org/r/20220621125144.5623-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/build-id.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -872,6 +872,30 @@ out_free:
 	return err;
 }
 
+static int filename__read_build_id_ns(const char *filename,
+				      struct build_id *bid,
+				      struct nsinfo *nsi)
+{
+	struct nscookie nsc;
+	int ret;
+
+	nsinfo__mountns_enter(nsi, &nsc);
+	ret = filename__read_build_id(filename, bid);
+	nsinfo__mountns_exit(&nsc);
+
+	return ret;
+}
+
+static bool dso__build_id_mismatch(struct dso *dso, const char *name)
+{
+	struct build_id bid;
+
+	if (filename__read_build_id_ns(name, &bid, dso->nsinfo) < 0)
+		return false;
+
+	return !dso__build_id_equal(dso, &bid);
+}
+
 static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 			       void *priv __maybe_unused)
 {
@@ -886,6 +910,10 @@ static int dso__cache_build_id(struct ds
 		is_kallsyms = true;
 		name = machine->mmap_name;
 	}
+
+	if (!is_kallsyms && dso__build_id_mismatch(dso, name))
+		return 0;
+
 	return build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
 				     is_kallsyms, is_vdso);
 }


