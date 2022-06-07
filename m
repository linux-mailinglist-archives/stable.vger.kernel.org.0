Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E556A54159F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359492AbiFGUhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378175AbiFGUez (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3CE1EA86E;
        Tue,  7 Jun 2022 11:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A364BCE23F1;
        Tue,  7 Jun 2022 18:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90629C385A2;
        Tue,  7 Jun 2022 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627057;
        bh=wXIZJawWrOCnO9b2OaTQyjOEM/LeOCNedPaXi6O7/l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWU2mNZvGmk2KNPVqh+Us33cd+CnVdvyaoV4Oh1dE9kC6p9eStoIFiKgC6J7tpoLW
         8QdaKoP0lZN9Y5Fw7kH5ptDGhvxpdFltuVLwGJJVCYvQgju+q4dGViggdiRG+POfaM
         SW26ij2GANbevqanSajsz+1nwgUDL3iIhmW1xZQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveria <bristot@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        John Kacur <jkacur@redhat.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 600/772] rtla: Dont overwrite existing directory mode
Date:   Tue,  7 Jun 2022 19:03:12 +0200
Message-Id: <20220607165006.622107220@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 5a1eda617992..4b635d4de018 100644
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



