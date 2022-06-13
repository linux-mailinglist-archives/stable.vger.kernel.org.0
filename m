Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F395489BD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378997AbiFMNqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379149AbiFMNnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE2B3ED39;
        Mon, 13 Jun 2022 04:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A668161260;
        Mon, 13 Jun 2022 11:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A45C34114;
        Mon, 13 Jun 2022 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119909;
        bh=DomDQ4mdKcRF9vS+JjxZAcDVVlPSmxLS53QjuIlwXMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHBTFcPldpB9wzARIk+momIYB+OvegURGU1rEQu4xjEwCD+4ZQXOGRWcGuPxnQ1o9
         xQp3vMjxpk1rq8bMVThBlU229xnzZ7bwreVFb5PDWzCkMGyc/GhsVuYcMQhS+lEZzQ
         NJ8DwchJbFq6x5k6WGpB7RmCw9Te3Z+MVxdS6kng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 174/339] rtla/Makefile: Properly handle dependencies
Date:   Mon, 13 Jun 2022 12:09:59 +0200
Message-Id: <20220613094931.954991873@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit fe4d0d5dde457bb5832b866418b5036f4f0c8d13 ]

Linus had a problem compiling RTLA, saying:

"[...] I wish the tracing tools would do a bit more package
checking and helpful error messages too, rather than just
fail with:

    fatal error: tracefs.h: No such file or directory"

Which is indeed not a helpful message. Update the Makefile, adding
proper checks for the dependencies, with useful information about
how to resolve possible problems.

For example, the previous error is now reported as:

    $ make
    ********************************************
    ** NOTICE: libtracefs version 1.3 or higher not found
    **
    ** Consider installing the latest libtracefs from your
    ** distribution, e.g., 'dnf install libtracefs' on Fedora,
    ** or from source:
    **
    **  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
    **
    ********************************************

These messages are inspired by the ones used on trace-cmd, as suggested
by Stevel Rostedt.

Link: https://lore.kernel.org/r/CAHk-=whxmA86E=csNv76DuxX_wYsg8mW15oUs3XTabu2Yc80yw@mail.gmail.com/

Changes from V1:
 - Moved the rst2man check to the install phase (when it is used).
 - Removed the procps-ng lib check [1] as it is being removed.

[1] a0f9f8c1030c66305c9b921057c3d483064d5529.1651220820.git.bristot@kernel.org

Link: https://lkml.kernel.org/r/3f1fac776c37e4b67c876a94e5a0e45ed022ff3d.1651238057.git.bristot@kernel.org

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/tools/rtla/Makefile | 14 ++++++++++++-
 tools/tracing/rtla/Makefile       | 35 +++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/tools/rtla/Makefile b/Documentation/tools/rtla/Makefile
index 9f2b84af1a6c..093af6d7a0e9 100644
--- a/Documentation/tools/rtla/Makefile
+++ b/Documentation/tools/rtla/Makefile
@@ -17,9 +17,21 @@ DOC_MAN1	= $(addprefix $(OUTPUT),$(_DOC_MAN1))
 RST2MAN_DEP	:= $(shell command -v rst2man 2>/dev/null)
 RST2MAN_OPTS	+= --verbose
 
+TEST_RST2MAN = $(shell sh -c "rst2man --version > /dev/null 2>&1 || echo n")
+
 $(OUTPUT)%.1: %.rst
 ifndef RST2MAN_DEP
-	$(error "rst2man not found, but required to generate man pages")
+	$(info ********************************************)
+	$(info ** NOTICE: rst2man not found)
+	$(info **)
+	$(info ** Consider installing the latest rst2man from your)
+	$(info ** distribution, e.g., 'dnf install python3-docutils' on Fedora,)
+	$(info ** or from source:)
+	$(info **)
+	$(info **  https://docutils.sourceforge.io/docs/dev/repository.html )
+	$(info **)
+	$(info ********************************************)
+	$(error NOTICE: rst2man required to generate man pages)
 endif
 	rst2man $(RST2MAN_OPTS) $< > $@
 
diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 523f0a8c38c2..3822f4ea5f49 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -58,6 +58,41 @@ else
 DOCSRC	=	$(SRCTREE)/../../../Documentation/tools/rtla/
 endif
 
+LIBTRACEEVENT_MIN_VERSION = 1.5
+LIBTRACEFS_MIN_VERSION = 1.3
+
+TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) libtraceevent > /dev/null 2>&1 || echo n")
+ifeq ("$(TEST_LIBTRACEEVENT)", "n")
+.PHONY: warning_traceevent
+warning_traceevent:
+	@echo "********************************************"
+	@echo "** NOTICE: libtraceevent version $(LIBTRACEEVENT_MIN_VERSION) or higher not found"
+	@echo "**"
+	@echo "** Consider installing the latest libtraceevent from your"
+	@echo "** distribution, e.g., 'dnf install libtraceevent' on Fedora,"
+	@echo "** or from source:"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/ "
+	@echo "**"
+	@echo "********************************************"
+endif
+
+TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) libtracefs > /dev/null 2>&1 || echo n")
+ifeq ("$(TEST_LIBTRACEFS)", "n")
+.PHONY: warning_tracefs
+warning_tracefs:
+	@echo "********************************************"
+	@echo "** NOTICE: libtracefs version $(LIBTRACEFS_MIN_VERSION) or higher not found"
+	@echo "**"
+	@echo "** Consider installing the latest libtracefs from your"
+	@echo "** distribution, e.g., 'dnf install libtracefs' on Fedora,"
+	@echo "** or from source:"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ "
+	@echo "**"
+	@echo "********************************************"
+endif
+
 .PHONY:	all
 all:	rtla
 
-- 
2.35.1



