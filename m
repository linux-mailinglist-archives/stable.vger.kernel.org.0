Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB9F2C9C3F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390216AbgLAJQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390308AbgLAJO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C121022240;
        Tue,  1 Dec 2020 09:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814027;
        bh=C+gbUkguOSKc2B34TzXK9xji5pbE8YI3SBahlnIfLoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNI7Jg6fm7TB/Up+qbRwExuAVnHpze6nkfuaO2BipMEKFeMbgG9ksNtUNYeVQn1kf
         8l999KGnonMjgVKhlu6n4Bb4X/RICRpR2zqZPPuqGciVWTSThpsfC+i71k4iHuBzzv
         OwZf/lKb4VH7dirx8YG15sUATbKvd257wBnzvwok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 140/152] perf probe: Fix to die_entrypc() returns error correctly
Date:   Tue,  1 Dec 2020 09:54:15 +0100
Message-Id: <20201201084730.140799760@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit ab4200c17ba6fe71d2da64317aae8a8aa684624c ]

Fix die_entrypc() to return error correctly if the DIE has no
DW_AT_ranges attribute. Since dwarf_ranges() will treat the case as an
empty ranges and return 0, we have to check it by ourselves.

Fixes: 91e2f539eeda ("perf probe: Fix to show function entry line as probe-able")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: http://lore.kernel.org/lkml/160645612634.2824037.5284932731175079426.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index aa898014ad12f..03c1a39c312a8 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -373,6 +373,7 @@ bool die_is_func_def(Dwarf_Die *dw_die)
 int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr)
 {
 	Dwarf_Addr base, end;
+	Dwarf_Attribute attr;
 
 	if (!addr)
 		return -EINVAL;
@@ -380,6 +381,13 @@ int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr)
 	if (dwarf_entrypc(dw_die, addr) == 0)
 		return 0;
 
+	/*
+	 *  Since the dwarf_ranges() will return 0 if there is no
+	 * DW_AT_ranges attribute, we should check it first.
+	 */
+	if (!dwarf_attr(dw_die, DW_AT_ranges, &attr))
+		return -ENOENT;
+
 	return dwarf_ranges(dw_die, 0, &base, addr, &end) < 0 ? -ENOENT : 0;
 }
 
-- 
2.27.0



