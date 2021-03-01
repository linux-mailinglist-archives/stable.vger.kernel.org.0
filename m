Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A362329078
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbhCAUIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242505AbhCAT6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:58:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67CF46526E;
        Mon,  1 Mar 2021 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621382;
        bh=kjqiA6plLeiKO59VpAyoxiPy5+m+iW51KNLv0wZxf+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeDnquMpR8WH8o9/Ms47CQ9L7UiykBjxdK7rQNOLt16CQ7y3fegJuW42SUi5hIuKu
         mFixxjzMXYx536H4tRXXd7hsE1yI4TVSvnzwsHxXElJTv9+AqQZ/W9cYdmWIIsoY9B
         uF7gZao10firKhGWEZ2XLTkNuG/zzqpaHgZ/jZI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Rigby <d.rigby@me.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 466/775] perf unwind: Set userdata for all __report_module() paths
Date:   Mon,  1 Mar 2021 17:10:34 +0100
Message-Id: <20210301161224.580936278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Rigby <d.rigby@me.com>

[ Upstream commit 4e1481445407b86a483616c4542ffdc810efb680 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/unwind-libdw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 0ada907c60d49..a74b517f74974 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -60,10 +60,8 @@ static int __report_module(struct addr_location *al, u64 ip,
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
@@ -79,6 +77,13 @@ static int __report_module(struct addr_location *al, u64 ip,
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
 
-- 
2.27.0



