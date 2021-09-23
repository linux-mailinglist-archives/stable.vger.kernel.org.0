Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D4F4154BA
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 02:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbhIWAkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 20:40:53 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:53500 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbhIWAkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 20:40:52 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 18N0clih029699; Thu, 23 Sep 2021 09:38:47 +0900
X-Iguazu-Qid: 2wHHCQcinQzg5OFCQS
X-Iguazu-QSIG: v=2; s=0; t=1632357527; q=2wHHCQcinQzg5OFCQS; m=ZuHUEa7i9BrAC1feDBNXJ6EM7z+cOj5mfESvZXYMN8A=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1112) id 18N0cir4016872
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Sep 2021 09:38:45 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 829DA100111;
        Thu, 23 Sep 2021 09:38:44 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 18N0chbW025381;
        Thu, 23 Sep 2021 09:38:44 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn " <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.14, 4.19, 5.4] apparmor: remove duplicate macro list_entry_is_head()
Date:   Thu, 23 Sep 2021 09:38:41 +0900
X-TSB-HOP: ON
Message-Id: <20210923003841.29792-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9801ca279ad37f72f71234fa81722afd95a3f997 upstream

Strangely I hadn't had noticed the existence of the list_entry_is_head()
in apparmor code when added the same one in the list.h.  Luckily it's
fully identical and didn't break builds.  In any case we don't need a
duplicate anymore, thus remove it from apparmor code.

Link: https://lkml.kernel.org/r/20201208100639.88182-1-andriy.shevchenko@linux.intel.com
Fixes: e130816164e244 ("include/linux/list.h: add a macro to test if entry is pointing to the head")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E . Hallyn " <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 security/apparmor/apparmorfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 1ec1e928cc09cd..900c865b9e5ffe 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1960,9 +1960,6 @@ int __aafs_ns_mkdir(struct aa_ns *ns, struct dentry *parent, const char *name,
 	return error;
 }
 
-
-#define list_entry_is_head(pos, head, member) (&pos->member == (head))
-
 /**
  * __next_ns - find the next namespace to list
  * @root: root namespace to stop search at (NOT NULL)
-- 
2.33.0


