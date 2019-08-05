Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0B4811A9
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfHEFfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:35:50 -0400
Received: from conuserg-12.nifty.com ([210.131.2.79]:40589 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfHEFfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:35:50 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x755ZJ7s024705;
        Mon, 5 Aug 2019 14:35:19 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x755ZJ7s024705
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564983320;
        bh=TbK6VAq503EXh72UIZZuMWC50YcF7dIdIDwOWGY2OTM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZNLrWcTUu39C3VwvDAAnePg8O1iS4uTO+rxAC3nwLyQV9e4M8gqQOf2O/LfKDJ2g1
         LskI7ynF7xfL1mAkg4FaIsnYSfzO+SAaQldPouOfeG3MmnhifyNip5yMBTS0Z++Jvw
         mIfxqtqYB6/6A+7SRtUR/IOl8nXRZ6BFGlYLcae1tAfJXL9Ygh2aZSJMVtu9KVkaod
         oi+Grcw2Av38lEK38FTtNRymVWL8IGn7pLjEBAHijhtKD8kLpoRIDJYiZzvnq49IHH
         8bW3S7u2UOQPLulBZ/5DcyOQQ7m6eL/4XvnW+JQnd7jCCPTIX6221Hxzln5yFlxLkA
         Wy7mxp8Jha6bw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 5.1.x] kconfig: Clear "written" flag to avoid data loss
Date:   Mon,  5 Aug 2019 14:35:13 +0900
Message-Id: <20190805053513.29629-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "M. Vefa Bicakci" <m.v.b@runbox.com>

commit 0c5b6c28ed68becb692b43eae5e44d5aa7e160ce upstream.

Prior to this commit, starting nconfig, xconfig or gconfig, and saving
the .config file more than once caused data loss, where a .config file
that contained only comments would be written to disk starting from the
second save operation.

This bug manifests itself because the SYMBOL_WRITTEN flag is never
cleared after the first call to conf_write, and subsequent calls to
conf_write then skip all of the configuration symbols due to the
SYMBOL_WRITTEN flag being set.

This commit resolves this issue by clearing the SYMBOL_WRITTEN flag
from all symbols before conf_write returns.

Fixes: 8e2442a5f86e ("kconfig: fix missing choice values in auto.conf")
Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---
 scripts/kconfig/confdata.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index fd99ae90a618..0dde19cf7486 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -784,6 +784,7 @@ int conf_write(const char *name)
 	const char *str;
 	char dirname[PATH_MAX+1], tmpname[PATH_MAX+22], newname[PATH_MAX+8];
 	char *env;
+	int i;
 
 	dirname[0] = 0;
 	if (name && name[0]) {
@@ -860,6 +861,9 @@ int conf_write(const char *name)
 	}
 	fclose(out);
 
+	for_all_symbols(i, sym)
+		sym->flags &= ~SYMBOL_WRITTEN;
+
 	if (*tmpname) {
 		strcat(dirname, basename);
 		strcat(dirname, ".old");
-- 
2.17.1

