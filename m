Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91E33931FC
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbhE0POo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236878AbhE0POn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CE7613BF;
        Thu, 27 May 2021 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128389;
        bh=3yNOj5++PHfWawBsKTMH8sT6z9qB4FaUjWSAGNh9MhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGbPbrDH/Ol2Zygc/CGe5j8/Wvad/tSDSQESzIenOIPWT2w4+4nK7aL+ZnJJDBxbC
         mtrzdxOGjI9WhqpymJatASWVOgpq44C49gaCp0DrPEjFZQi37wp8MZTwrPPX9zB+Vc
         8mJZHqWrin6fvkQWFs4cj5mGFg0tyun3snanemAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Rigby <d.rigby@me.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Tommi Rantala" <tommi.t.rantala@nokia.com>
Subject: [PATCH 5.4 6/7] perf unwind: Set userdata for all __report_module() paths
Date:   Thu, 27 May 2021 17:12:48 +0200
Message-Id: <20210527151139.422851630@linuxfoundation.org>
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
 


