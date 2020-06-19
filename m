Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEEF2016D7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbgFSOpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388635AbgFSOpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C7D720A8B;
        Fri, 19 Jun 2020 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577902;
        bh=24pwdUzcMDZRBBugaK3JG3KsNX5fzvdkgzFFU+nTSTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRVdGwk+c+nzMgnyb8nuWI9FI3gaCYCECwAfBL8To+Pr1NFOJh3JKqAdget39QGKl
         MXm8jUdLGIH1l/O8A+geRJ3ao3mrLw/8+LECfCqGi5KOEnRtlj1WG/pQXTknDRVmxh
         SZD7UX4pjdDxQaaQuV8poAsIHKG71k+zQ61d5cRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Travis Downs <travis.downs@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 128/128] perf symbols: Fix debuginfo search for Ubuntu
Date:   Fri, 19 Jun 2020 16:33:42 +0200
Message-Id: <20200619141626.842493077@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
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
@@ -19,6 +19,7 @@ char dso__symtab_origin(const struct dso
 		[DSO_BINARY_TYPE__BUILD_ID_CACHE]		= 'B',
 		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]		= 'f',
 		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]		= 'u',
+		[DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO]	= 'x',
 		[DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO]	= 'o',
 		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]		= 'b',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]		= 'd',
@@ -77,6 +78,21 @@ int dso__read_binary_type_filename(const
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
@@ -22,6 +22,7 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__BUILD_ID_CACHE,
 	DSO_BINARY_TYPE__FEDORA_DEBUGINFO,
 	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
+	DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -111,6 +111,7 @@ enum dso_binary_type distro_dwarf_types[
 	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
+	DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -58,6 +58,7 @@ static enum dso_binary_type binary_type_
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
+	DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
@@ -1361,6 +1362,7 @@ static bool dso__is_compatible_symtab_ty
 	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
 	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
 	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
+	case DSO_BINARY_TYPE__MIXEDUP_UBUNTU_DEBUGINFO:
 	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
 	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
 		return !kmod && dso->kernel == DSO_TYPE_USER;


