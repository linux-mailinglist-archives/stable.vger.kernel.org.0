Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC59B805A0
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 12:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbfHCKCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 06:02:38 -0400
Received: from aibo.runbox.com ([91.220.196.211]:53114 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388294AbfHCKCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 06:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=rbselector1; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=h+gdKezhnZxQ2ykgMTawflCtKVKbt31AwdXjqem/yp4=; b=kXg+/nu/KXVcgabR+VYTZ+FOFH
        B5CRSmbOda9oLmMjdFY1MNMZ11kdtIUJ/kPzxLxXdomCwbcIiaGYMXGUsaXesn9utWvJb8jvJ7+Vf
        7lQSjRURki80BihrM2Lf2+vSDHGH0JAiTmFnIiS6ZOTlZcxmLZ4zb/ZvtOcc1Y08961aiCcGc/LVX
        CKFIjG539a+5BPXBE15P6WZlLpvv4yw9kpGSHcEKJw6i9alPqchZRmDnmH8t9B9DEZIYlwYcURZDh
        2T35Jk+MHD8KTqKDJy5mTrskGTb4KJzm+g/7xv4qGU8yElM0gn7yaUvgyVQ/+Q6MTJkY/80TBq4pa
        8mgtGCZg==;
Received: from [10.9.9.203] (helo=mailfront21.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1htqrv-0006ih-Ou; Sat, 03 Aug 2019 12:02:31 +0200
Received: by mailfront21.runbox with esmtpsa  (uid:769847 )  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1htqrj-0007Lk-4g; Sat, 03 Aug 2019 12:02:19 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     =?UTF-8?q?Joonas=20Kylm=C3=A4l=C3=A4?= <joonas.kylmala@iki.fi>,
        Ulf Magnusson <ulfalizer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
Date:   Sat,  3 Aug 2019 06:02:12 -0400
Message-Id: <20190803100212.8227-1-m.v.b@runbox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <CAK7LNASPib2GUgjUEwmNYcO9_NgvjyjKSpqwJVZSNhFOJ7Lkfw@mail.gmail.com>
References: <CAK7LNASPib2GUgjUEwmNYcO9_NgvjyjKSpqwJVZSNhFOJ7Lkfw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---

Changes since v1:
* As suggested by Masahiro Yamada, instead of defining a new helper
  function to traverse over all symbols in a pre-defined order, use
  the for_all_symbols iterator.
---
 scripts/kconfig/confdata.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 1134892599da..3569d2dec37c 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -848,6 +848,7 @@ int conf_write(const char *name)
 	const char *str;
 	char tmpname[PATH_MAX + 1], oldname[PATH_MAX + 1];
 	char *env;
+	int i;
 	bool need_newline = false;
 
 	if (!name)
@@ -930,6 +931,9 @@ int conf_write(const char *name)
 	}
 	fclose(out);
 
+	for_all_symbols(i, sym)
+		sym->flags &= ~SYMBOL_WRITTEN;
+
 	if (*tmpname) {
 		if (is_same(name, tmpname)) {
 			conf_message("No change to %s", name);
-- 
2.21.0

