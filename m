Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DDB3931FD
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbhE0POo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236902AbhE0POk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC9C60724;
        Thu, 27 May 2021 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128387;
        bh=P4cHp4mjoWKDoBbgpH4pQLwRbAbw8CpoL9g8GbHVnSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkVmHVQq1/Y+blIlzD72nkS/I0OO7I0JNy5ASp3vqkIb5cb3AU2Xcge/t0SGWGUZt
         SrFsfwLMFf4Kusppv5RoU49KuEIc2b7qsGP90+bggowwcspw1/2zVVCLrdIGXPXuET
         TboSydx+l65sX8vrC7tW9uDEjIvlIGxfbsXiTC+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Tommi Rantala" <tommi.t.rantala@nokia.com>
Subject: [PATCH 5.4 5/7] perf unwind: Fix separate debug info files when using elfutils libdws unwinder
Date:   Thu, 27 May 2021 17:12:47 +0200
Message-Id: <20210527151139.394008531@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
References: <20210527151139.224619013@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kratochvil <jan.kratochvil@redhat.com>

commit bf53fc6b5f415cddc7118091cb8fd6a211b2320d upstream.

elfutils needs to be provided main binary and separate debug info file
respectively. Providing separate debug info file instead of the main
binary is not sufficient.

One needs to try both supplied filename and its possible cache by its
build-id depending on the use case.

Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Tommi Rantala" <tommi.t.rantala@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/unwind-libdw.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -20,10 +20,24 @@
 
 static char *debuginfo_path;
 
+static int __find_debuginfo(Dwfl_Module *mod __maybe_unused, void **userdata,
+			    const char *modname __maybe_unused, Dwarf_Addr base __maybe_unused,
+			    const char *file_name, const char *debuglink_file __maybe_unused,
+			    GElf_Word debuglink_crc __maybe_unused, char **debuginfo_file_name)
+{
+	const struct dso *dso = *userdata;
+
+	assert(dso);
+	if (dso->symsrc_filename && strcmp (file_name, dso->symsrc_filename))
+		*debuginfo_file_name = strdup(dso->symsrc_filename);
+	return -1;
+}
+
 static const Dwfl_Callbacks offline_callbacks = {
-	.find_debuginfo		= dwfl_standard_find_debuginfo,
+	.find_debuginfo		= __find_debuginfo,
 	.debuginfo_path		= &debuginfo_path,
 	.section_address	= dwfl_offline_section_address,
+	// .find_elf is not set as we use dwfl_report_elf() instead.
 };
 
 static int __report_module(struct addr_location *al, u64 ip,
@@ -46,16 +60,24 @@ static int __report_module(struct addr_l
 	mod = dwfl_addrmodule(ui->dwfl, ip);
 	if (mod) {
 		Dwarf_Addr s;
+		void **userdatap;
 
-		dwfl_module_info(mod, NULL, &s, NULL, NULL, NULL, NULL, NULL);
+		dwfl_module_info(mod, &userdatap, &s, NULL, NULL, NULL, NULL, NULL);
+		*userdatap = dso;
 		if (s != al->map->start - al->map->pgoff)
 			mod = 0;
 	}
 
 	if (!mod)
-		mod = dwfl_report_elf(ui->dwfl, dso->short_name,
-				      (dso->symsrc_filename ? dso->symsrc_filename : dso->long_name), -1, al->map->start - al->map->pgoff,
-				      false);
+		mod = dwfl_report_elf(ui->dwfl, dso->short_name, dso->long_name, -1,
+				      al->map->start - al->map->pgoff, false);
+	if (!mod) {
+		char filename[PATH_MAX];
+
+		if (dso__build_id_filename(dso, filename, sizeof(filename), false))
+			mod = dwfl_report_elf(ui->dwfl, dso->short_name, filename, -1,
+					      al->map->start - al->map->pgoff, false);
+	}
 
 	return mod && dwfl_addrmodule(ui->dwfl, ip) == mod ? 0 : -1;
 }


