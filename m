Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE61880387
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 02:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391992AbfHCAf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 20:35:26 -0400
Received: from aibo.runbox.com ([91.220.196.211]:32998 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390153AbfHCAf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 20:35:26 -0400
X-Greylist: delayed 2543 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 20:35:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=rbselector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
        bh=TazsGP7cxXXZSH2JMdVr/ycQv/4+Lei21hIYlZrb6xM=; b=mSZhvIMybaEUGW2OxkQfP8J5QB
        igMTDE0QXHFlO3lb0R+yQULAbE3S+M1bMoVYT8uGb1mWkLiRm7XegpBzkz8DlRLMY5UCGefdlqo2f
        0mgXs1D/giWOKJlfyzm8+shV6sYdI6cmF6cMDnoILREV66eFRjMRe3V+aOMe7rdAizXGE2WDZ2xiF
        vxTNK6a/awBRFGvn2hKDUkVWjdxbxfZ/WEm2Ay+6o5BvE2QDbXmXxPEiwplHhhQ+/6nq2IaTprvkF
        u2uz+j80/xZ338ZrqqrfuFKEHrWmo0me2j0EMZFuVgAITbhu7NFvsOV4B4qlC1vnvSiXlhkDcMGiu
        MFQ64LQw==;
Received: from [10.9.9.203] (helo=mailfront21.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1hthM4-0003Go-ED; Sat, 03 Aug 2019 01:53:00 +0200
Received: by mailfront21.runbox with esmtpsa  (uid:769847 )  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1hthLu-0002Rb-L9; Sat, 03 Aug 2019 01:52:51 +0200
Date:   Fri, 2 Aug 2019 19:52:43 -0400
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-kbuild@vger.kernel.org, joonas.kylmala@iki.fi,
        ulfalizer@gmail.com, linux-stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix missing choice values in auto.conf
Message-ID: <20190802195243.09a87651@runbox.com>
In-Reply-To: <20190712060709.20609-1-yamada.masahiro@socionext.com>
References: <20190712060709.20609-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

> conf_write() must be changed accordingly. Currently, it clears
> SYMBOL_WRITE after the symbol is written into the .config file. This
> is needed to prevent it from writing the same symbol multiple times in
> case the symbol is declared in two or more locations. I added the new
> flag SYMBOL_WRITTEN, to track the symbols that have been written.
[snip]
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index cbb6efa4a5a6..e0972b255aac 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
[snip]
> @@ -903,7 +904,7 @@ int conf_write(const char *name)
>  				fprintf(out, "\n");
>  				need_newline = false;
>  			}
> -			sym->flags &= ~SYMBOL_WRITE;
> +			sym->flags |= SYMBOL_WRITTEN;

The SYMBOL_WRITTEN flag is never cleared after being set in this
function, which unfortunately causes data loss to occur when a user
starts xconfig, gconfig, or nconfig and saves a config file more than
once. Every save operation after the first one causes the saved .config
file to contain only comments.

I am appending a patch that resolves this issue. The patch is a bit
ugly because of the code duplication, but it fixes this bug. (I have
lightly tested the patch.) Even if the patch is not merged, I would
appreciate it if this bug could be fixed.

Thank you,

Vefa

=== 8< === Patch Follows === >8 ===

From: "M. Vefa Bicakci" <m.v.b@runbox.com>
Date: Fri, 2 Aug 2019 17:44:40 -0400
Subject: [PATCH] kconfig: Clear "written" flag to avoid data loss

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
 scripts/kconfig/confdata.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 1134892599da..24fe0c851e8c 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -840,6 +840,35 @@ int conf_write_defconfig(const char *filename)
 	return 0;
 }
 
+static void conf_clear_written_flag(void)
+{
+	struct menu *menu;
+	struct symbol *sym;
+
+	menu = rootmenu.list;
+	while (menu) {
+		sym = menu->sym;
+		if (sym && (sym->flags & SYMBOL_WRITTEN))
+			sym->flags &= ~SYMBOL_WRITTEN;
+
+		if (menu->list) {
+			menu = menu->list;
+			continue;
+		}
+
+		if (menu->next) {
+			menu = menu->next;
+		} else {
+			while ((menu = menu->parent)) {
+				if (menu->next) {
+					menu = menu->next;
+					break;
+				}
+			}
+		}
+	}
+}
+
 int conf_write(const char *name)
 {
 	FILE *out;
@@ -930,6 +959,8 @@ int conf_write(const char *name)
 	}
 	fclose(out);
 
+	conf_clear_written_flag();
+
 	if (*tmpname) {
 		if (is_same(name, tmpname)) {
 			conf_message("No change to %s", name);
-- 
2.21.0

