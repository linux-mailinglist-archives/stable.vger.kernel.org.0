Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC5F393218
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbhE0PPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237022AbhE0PPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A26F6613BA;
        Thu, 27 May 2021 15:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128412;
        bh=3yNOj5++PHfWawBsKTMH8sT6z9qB4FaUjWSAGNh9MhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E28HPgqjU79S8FA4wscakK3nPt5o816fEJX+n50J0sVZfixm/hEDnNihs2Zum5QMZ
         f34AlnfsQSUqYNbPtD/v9FFhBuunDta1jpGG87whEHRLCha7p93UOF65TXrxOsoytV
         pDNwn8aNcFrf8cLuVkd47T3kjNwh2jEmIsKki4I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Rigby <d.rigby@me.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Tommi Rantala" <tommi.t.rantala@nokia.com>
Subject: [PATCH 5.10 8/9] perf unwind: Set userdata for all __report_module() paths
Date:   Thu, 27 May 2021 17:13:00 +0200
Message-Id: <20210527151139.507069037@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
References: <20210527151139.242182390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Rigby <d.rigby@me.com>

commit 4e1481445407b86a483616c4542ffdc810efb680 upstream.

When locating the DWARF module for a given address, __find_debuginfo()
requires a 'struct dso' passed via the userdata argument.

However, this field is only set in __report_module() if the module is
found in via dwfl_addrmodule(), not if it is found later via
dwfl_report_elf().

Set userdata irrespective of how the DWARF module was found, as long as
we found a module.

Fixes: bf53fc6b5f41 ("perf unwind: Fix separate debug info files when using elfutils' libdw's unwinder")
Signed-off-by: Dave Rigby <d.rigby@me.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211801
Acked-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/linux-perf-users/20210218165654.36604-1-d.rigby@me.com/
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Tommi Rantala" <tommi.t.rantala@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/unwind-libdw.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -60,10 +60,8 @@ static int __report_module(struct addr_l
 	mod = dwfl_addrmodule(ui->dwfl, ip);
 	if (mod) {
 		Dwarf_Addr s;
-		void **userdatap;
 
-		dwfl_module_info(mod, &userdatap, &s, NULL, NULL, NULL, NULL, NULL);
-		*userdatap = dso;
+		dwfl_module_info(mod, NULL, &s, NULL, NULL, NULL, NULL, NULL);
 		if (s != al->map->start - al->map->pgoff)
 			mod = 0;
 	}
@@ -79,6 +77,13 @@ static int __report_module(struct addr_l
 					      al->map->start - al->map->pgoff, false);
 	}
 
+	if (mod) {
+		void **userdatap;
+
+		dwfl_module_info(mod, &userdatap, NULL, NULL, NULL, NULL, NULL, NULL);
+		*userdatap = dso;
+	}
+
 	return mod && dwfl_addrmodule(ui->dwfl, ip) == mod ? 0 : -1;
 }
 


