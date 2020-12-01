Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568FA2C9AEB
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388657AbgLAJCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388643AbgLAJCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCEE20671;
        Tue,  1 Dec 2020 09:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813298;
        bh=GWzSPCgvJLv1OoLb7dNBzwaz9Od3Hn/Fpf8xBrBwdMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D18QmsscuZyay1W5hS8dVBjfd47HAVQyZib1VZgTVjjBYLTXwlPZdJ+0qH610pTOQ
         +0vFhpKUR4TpkahTTZvnVCWBN5IDSbiL6HI5bQptG3KVsJGpT/hb37V+BHecxkBJ5Y
         vwiT9mSPlynvPKHS8TToQsKUXgUKsvavyMx6q5+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/57] perf probe: Fix to die_entrypc() returns error correctly
Date:   Tue,  1 Dec 2020 09:53:54 +0100
Message-Id: <20201201084651.520449776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
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
index 29e75c051d045..230e94bf7775a 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -332,6 +332,7 @@ bool die_is_func_def(Dwarf_Die *dw_die)
 int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr)
 {
 	Dwarf_Addr base, end;
+	Dwarf_Attribute attr;
 
 	if (!addr)
 		return -EINVAL;
@@ -339,6 +340,13 @@ int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr)
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



