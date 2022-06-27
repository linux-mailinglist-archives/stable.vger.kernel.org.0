Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064D055DB26
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiF0KmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 06:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiF0KmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 06:42:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246FD641E
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 03:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E44A6130D
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 10:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A8BC3411D;
        Mon, 27 Jun 2022 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656326532;
        bh=UIqurtuK2FB8qsaWz6k3g3Gn9GScnlL5HRU4PZrhyZQ=;
        h=Subject:To:Cc:From:Date:From;
        b=wZzh7ko/YlakpqLLKpgvJS5rz97KQXvlhIRMMfobqXdUnFDIUMu645GnNSsnsyEOC
         gQIeSr3fX3R3+XQEqyaGn5YymV3mIZaOOvx9SvFy0YaVt5bUeDH2cSUvMi1F1tbjsI
         yhiUTkWdEKh6W+JlMSuTvr2eo+4NL1mCX+3DwCZE=
Subject: FAILED: patch "[PATCH] perf build-id: Fix caching files with a wrong build ID" failed to apply to 4.19-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com, jolsa@kernel.org,
        namhyung@kernel.org, tzanussi@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 12:41:58 +0200
Message-ID: <1656326518240134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab66fdace8581ef3b4e7cf5381a168ed4058d779 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Tue, 21 Jun 2022 15:51:44 +0300
Subject: [PATCH] perf build-id: Fix caching files with a wrong build ID

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

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 82f3d46bea70..328668f38c69 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -872,6 +872,30 @@ int build_id_cache__remove_s(const char *sbuild_id)
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
@@ -886,6 +910,10 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
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

