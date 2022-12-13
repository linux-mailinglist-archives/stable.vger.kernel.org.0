Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2070364BB7D
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiLMSDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 13:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiLMSDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 13:03:42 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7082520352;
        Tue, 13 Dec 2022 10:03:40 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4NWmZf5rWVz9smn;
        Tue, 13 Dec 2022 19:03:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UCqxqYXXsQ8T; Tue, 13 Dec 2022 19:03:38 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4NWmZf4ybRz9smJ;
        Tue, 13 Dec 2022 19:03:38 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 998358B773;
        Tue, 13 Dec 2022 19:03:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id U_aiRmb3iWhf; Tue, 13 Dec 2022 19:03:38 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.7.67])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5EEE98B766;
        Tue, 13 Dec 2022 19:03:38 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 2BDI3NBF737221
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 19:03:23 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 2BDI3LhP737213;
        Tue, 13 Dec 2022 19:03:21 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] [BACKPORT FOR 4.14] libtraceevent: Fix build with binutils 2.35
Date:   Tue, 13 Dec 2022 19:03:07 +0100
Message-Id: <c4629a12d4a2a21ff131624d3ef1d9f8b5fd64ad.1670954579.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1670954585; l=1329; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=S7mrLyJvmUixcNAmwGFNK/txVTz4era2R9aIZnLMX2Y=; b=/7rRXy1Mh+5nF/pPOHuSwoiroRaCdraCGJQld2g8Ep1FH0UJXy92iMLkftOIuueBuB6hbY+h8pY8 nA3glJxhDvKjfUqzznkqivLGN+x/vFel/1wSLkc0SIdwNFRFDL22
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[upstream commit 39efdd94e314336f4acbac4c07e0f37bdc3bef71]

In binutils 2.35, 'nm -D' changed to show symbol versions along with
symbol names, with the usual @@ separator.  When generating
libtraceevent-dynamic-list we need just the names, so strip off the
version suffix if present.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index a0ac01c647f5..2d6989f8a87c 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -263,7 +263,7 @@ define do_generate_dynamic_list_file
 	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
 	if [ "$$symbol_type" = "U W" ];then				\
 		(echo '{';						\
-		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
+		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
 		echo '};';						\
 		) > $2;							\
 	else								\
-- 
2.38.1

