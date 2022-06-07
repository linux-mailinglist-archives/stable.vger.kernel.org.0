Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF01541D10
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378629AbiFGWHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383780AbiFGWGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010FF2514B7;
        Tue,  7 Jun 2022 12:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909D861929;
        Tue,  7 Jun 2022 19:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C750C385A2;
        Tue,  7 Jun 2022 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629461;
        bh=NrAeKNkxmSE5W5CrvSELKazV+if6cVxvBs1EbjA7sm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2K0KKnG7ODsGXjeopDzHxjWsZKPM8m76z5vJ1KFWzyBgNpA5t7IUPKegFrdhBHulk
         q8MzgHjdHj1yDhMSo1nMXEDml3odqqGEox1dV3mUhrn8W2sTOzwyny7ho0CVy/OGV9
         LzPZRywOM48s2armHKcOfTlz4yLoNpGTgMedi7gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveria <bristot@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        John Kacur <jkacur@redhat.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 699/879] rtla: Dont overwrite existing directory mode
Date:   Tue,  7 Jun 2022 19:03:37 +0200
Message-Id: <20220607165023.137393581@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: John Kacur <jkacur@redhat.com>

[ Upstream commit 39c3d84cb5b52792a7323a338334d8d65b2dbe3f ]

The mode on /usr/bin is often 555 these days,
but make install on rtla overwrites this with 755

Fix this by preserving the current directory if it exists.

Link: https://lkml.kernel.org/r/8c294a6961080a1970fd8b73f7bcf1e3984579e2.1651247710.git.bristot@kernel.org
Link: https://lore.kernel.org/r/20220402043939.6962-1-jkacur@redhat.com

Cc: Daniel Bristot de Oliveria <bristot@redhat.com>
Fixes: 79ce8f43ac5a ("rtla: Real-Time Linux Analysis tool")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 11fb417abb42..5a3226e436ef 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -23,6 +23,7 @@ $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
 $(call allow-override,LDCONFIG,ldconfig)
 
 INSTALL	=	install
+MKDIR	=	mkdir
 FOPTS	:=	-flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong \
 		-fasynchronous-unwind-tables -fstack-clash-protection
 WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
@@ -68,7 +69,7 @@ static: $(OBJ)
 
 .PHONY: install
 install: doc_install
-	$(INSTALL) -d -m 755 $(DESTDIR)$(BINDIR)
+	$(MKDIR) -p $(DESTDIR)$(BINDIR)
 	$(INSTALL) rtla -m 755 $(DESTDIR)$(BINDIR)
 	$(STRIP) $(DESTDIR)$(BINDIR)/rtla
 	@test ! -f $(DESTDIR)$(BINDIR)/osnoise || rm $(DESTDIR)$(BINDIR)/osnoise
-- 
2.35.1



