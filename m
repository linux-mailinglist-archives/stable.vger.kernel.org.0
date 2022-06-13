Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247A65488B9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356856AbiFMNHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352790AbiFMNFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:05:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A60377F1;
        Mon, 13 Jun 2022 04:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05E15B80EAF;
        Mon, 13 Jun 2022 11:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6E5C34114;
        Mon, 13 Jun 2022 11:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119094;
        bh=ZoIQx/4KSETmL1Fddvq3W5LMPWCMPRJ+iRqS9vyiepg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0YFFCGrUNSTJL7EjPLHGLQRO32iTmds5BjLZx6NttooVY9fBdqbxBZALpjihwLDO
         SBhLaLwbIX4mttbZIdHTXXFzKqFOgRTIH0ycLN/COM+Pmdbw/idyP8lETJapvb67Ml
         tX6sTQKTyhvJ0XYzhOSSApajjvgYllQ+Z2FZW5zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/247] bootconfig: Make the bootconfig.o as a normal object file
Date:   Mon, 13 Jun 2022 12:10:14 +0200
Message-Id: <20220613094926.359805431@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 6014a23638cdee63a71ef13c51d7c563eb5829ee ]

Since the APIs defined in the bootconfig.o are not individually used,
it is meaningless to build it as library by lib-y. Use obj-y for that.

Link: https://lkml.kernel.org/r/164921225875.1090670.15565363126983098971.stgit@devnote2

Cc: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index a841be5244ac..6cf97c60b00b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -275,7 +275,7 @@ $(foreach file, $(libfdt_files), \
 	$(eval CFLAGS_$(file) = -I $(srctree)/scripts/dtc/libfdt))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 
-lib-$(CONFIG_BOOT_CONFIG) += bootconfig.o
+obj-$(CONFIG_BOOT_CONFIG) += bootconfig.o
 
 obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
 obj-$(CONFIG_INTERVAL_TREE_TEST) += interval_tree_test.o
-- 
2.35.1



