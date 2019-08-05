Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB4A81040
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 04:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfHECWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 22:22:35 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:64913 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfHECWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 22:22:35 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x752M7pW025642;
        Mon, 5 Aug 2019 11:22:07 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x752M7pW025642
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564971727;
        bh=TbK6VAq503EXh72UIZZuMWC50YcF7dIdIDwOWGY2OTM=;
        h=From:To:Cc:Subject:Date:From;
        b=NauSU16L91uGEVC0RMjF/rt4fU0xPLH+c/bhjoLq3uqc8PL0pBz92uV8vb/rkNSZP
         QDgiALzJQh881aARtRB0xhbN7kBH9bwpGmuhDl6RLEM+GHgnXMneLfEnp6oULs0gSk
         S6PGj8ZRAIf9MlUL9CS5H1DYTWbCoM/0wncnTZzc6L+mgxr3tmzpyjXUHlQMXQSSfa
         PmUQhNRKYQ1XPorKgssGJOrTJwXpMWbBu7u4cvE4mRXLKAQdSB1qQHA5WYQ8D/t654
         sQ5pbLQy5IQNpakLxTXF1ZC5df5SErqG2ufY6VGFrHIgaQ1RMz2YwzmiMnSeKFBedi
         jwQPe+d1y7Hfw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 4.19.x] kconfig: Clear "written" flag to avoid data loss
Date:   Mon,  5 Aug 2019 11:21:43 +0900
Message-Id: <20190805022143.8657-1-yamada.masahiro@socionext.com>
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

