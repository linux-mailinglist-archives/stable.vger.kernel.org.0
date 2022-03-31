Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603B54EDB4B
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 16:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbiCaOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 10:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbiCaOGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 10:06:12 -0400
Received: from postfix03.core.dcmtl.stgraber.net (postfix03.core.dcmtl.stgraber.net [IPv6:2602:fc62:a:1003:216:3eff:fea3:3fe])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54905A165;
        Thu, 31 Mar 2022 07:04:08 -0700 (PDT)
Received: from dakara.stgraber.net (unknown [IPv6:2602:fc62:b:1000:5436:5b25:64e4:d81a])
        by postfix03.core.dcmtl.stgraber.net (Postfix) with ESMTP id 5B6762048C;
        Thu, 31 Mar 2022 14:04:06 +0000 (UTC)
From:   =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH] tools/vm/slabinfo: Handle files in debugfs
Date:   Thu, 31 Mar 2022 10:03:39 -0400
Message-Id: <20220331140339.1362390-1-stgraber@ubuntu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 64dd68497be76 relocated and renamed the alloc_calls and
free_calls files from /sys/kernel/slab/NAME/*_calls over to
/sys/kernel/debug/slab/NAME/*_calls but didn't update the slabinfo tool
with the new location.

This change will now have slabinfo look at the new location (and filenames)
with a fallback to the prior files.

Fixes: 64dd68497be76 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
Tested-by: Stéphane Graber <stgraber@ubuntu.com>
---
 tools/vm/slabinfo.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/vm/slabinfo.c b/tools/vm/slabinfo.c
index 9b68658b6bb8..5b98f3ee58a5 100644
--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -233,6 +233,24 @@ static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
 	return l;
 }
 
+static unsigned long read_debug_slab_obj(struct slabinfo *s, const char *name)
+{
+	char x[128];
+	FILE *f;
+	size_t l;
+
+	snprintf(x, 128, "/sys/kernel/debug/slab/%s/%s", s->name, name);
+	f = fopen(x, "r");
+	if (!f) {
+		buffer[0] = 0;
+		l = 0;
+	} else {
+		l = fread(buffer, 1, sizeof(buffer), f);
+		buffer[l] = 0;
+		fclose(f);
+	}
+	return l;
+}
 
 /*
  * Put a size string together
@@ -409,14 +427,18 @@ static void show_tracking(struct slabinfo *s)
 {
 	printf("\n%s: Kernel object allocation\n", s->name);
 	printf("-----------------------------------------------------------------------\n");
-	if (read_slab_obj(s, "alloc_calls"))
+	if (read_debug_slab_obj(s, "alloc_traces"))
+		printf("%s", buffer);
+	else if (read_slab_obj(s, "alloc_calls"))
 		printf("%s", buffer);
 	else
 		printf("No Data\n");
 
 	printf("\n%s: Kernel object freeing\n", s->name);
 	printf("------------------------------------------------------------------------\n");
-	if (read_slab_obj(s, "free_calls"))
+	if (read_debug_slab_obj(s, "free_traces"))
+		printf("%s", buffer);
+	else if (read_slab_obj(s, "free_calls"))
 		printf("%s", buffer);
 	else
 		printf("No Data\n");
-- 
2.34.1

