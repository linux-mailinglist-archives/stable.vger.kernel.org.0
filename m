Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDB8201884
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbgFSQtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388073AbgFSOjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:39:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEFD121548;
        Fri, 19 Jun 2020 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577583;
        bh=HJP2e/nn2YZnz09sd3zdBF6V+XvMe2EwKmmBhRJ+ga0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4vTBoycK29kTdYhMwH+JZzcURj1SrVbyQIVc0vE8Ac8qT6W0z3PI77KPDXjDyk3o
         Qp++mz7qq2wU3T3CgBQiSE9tYm1FPabc3uhg6BoD6w4Xzy4582j8Qyv203jB4+ECWX
         9naxXxboJRxbHAQeBuAdGnw241C//7a8gv1yiNzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Travis Downs <travis.downs@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.4 101/101] perf symbols: Fix debuginfo search for Ubuntu
Date:   Fri, 19 Jun 2020 16:33:30 +0200
Message-Id: <20200619141619.267759140@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 85afd35575a3c1a3a905722dde5ee70b49282e70 upstream.

Reportedly, from 19.10 Ubuntu has begun mixing up the location of some
debug symbol files, putting files expected to be in
/usr/lib/debug/usr/lib into /usr/lib/debug/lib instead. Fix by adding
another dso_binary_type.

Example on Ubuntu 20.04

  Before:

    $ perf record -e intel_pt//u uname
    Linux
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.030 MB perf.data ]
    $ perf script --call-trace | head -5
           uname 14003 [005] 15321.764958566:  cbr: 42 freq: 4219 MHz (156%)
           uname 14003 [005] 15321.764958566: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )          7f1e71cc4100
           uname 14003 [005] 15321.764961566: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )              7f1e71cc4df0
           uname 14003 [005] 15321.764961900: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )              7f1e71cc4e18
           uname 14003 [005] 15321.764963233: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )              7f1e71cc5128

  After:

    $ perf script --call-trace | head -5
           uname 14003 [005] 15321.764958566:  cbr: 42 freq: 4219 MHz (156%)
           uname 14003 [005] 15321.764958566: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )      _start
           uname 14003 [005] 15321.764961566: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )          _dl_start
           uname 14003 [005] 15321.764961900: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )          _dl_start
           uname 14003 [005] 15321.764963233: (/usr/lib/x86_64-linux-gnu/ld-2.31.so              )          _dl_start

Reported-by: Travis Downs <travis.downs@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200526155207.9172-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/dso.c          |   16 ++++++++++++++++
 tools/perf/util/dso.h          |    1 +
 tools/perf/util/probe-finder.c |    1 +
 tools/perf/util/symbol.c       |    2 ++
 4 files changed, 20 insertions(+)

--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -18,6 +18,7 @@ char dso__symtab_origin(const struct dso
 		[DSO_BINARY_TYPE__BUILD_ID_CACHE]		= 'B',
 		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]		= 'f',
 		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]		= 'u',
+		[DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO]	= 'x',
 		[DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO]	= 'o',
 		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]		= 'b',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]		= 'd',
@@ -73,6 +74,21 @@ int dso__read_binary_type_filename(const
 		snprintf(filename + len, size - len, "%s", dso->long_name);
 		break;
 
+	case DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO:
+		/*
+		 * Ubuntu can mixup /usr/lib with /lib, putting debuginfo in
+		 * /usr/lib/debug/lib when it is expected to be in
+		 * /usr/lib/debug/usr/lib
+		 */
+		if (strlen(dso->long_name) < 9 ||
+		    strncmp(dso->long_name, "/usr/lib/", 9)) {
+			ret = -1;
+			break;
+		}
+		len = __symbol__join_symfs(filename, size, "/usr/lib/debug");
+		snprintf(filename + len, size - len, "%s", dso->long_name + 4);
+		break;
+
 	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
 	{
 		const char *last_slash;
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -21,6 +21,7 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__BUILD_ID_CACHE,
 	DSO_BINARY_TYPE__FEDORA_DEBUGINFO,
 	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
+	DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -110,6 +110,7 @@ enum dso_binary_type distro_dwarf_types[
 	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
+	DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -56,6 +56,7 @@ static enum dso_binary_type binary_type_
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
+	DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
@@ -1363,6 +1364,7 @@ static bool dso__is_compatible_symtab_ty
 	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
 	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
 	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
+	case DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO:
 	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
 	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
 		return !kmod && dso->kernel == DSO_TYPE_USER;


