Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E205B59D681
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbiHWJKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348009AbiHWJJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83405868A1;
        Tue, 23 Aug 2022 01:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A2F761338;
        Tue, 23 Aug 2022 08:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26467C433C1;
        Tue, 23 Aug 2022 08:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243388;
        bh=bpP3v+DcvV2AxMnSmPB9/sNRdImi4ZKRLo9adOSSbiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhvolnvbPIzW7ZlSt/ikqR6/PqDz1HLG+KSsvvDDo7AyIz0mLtPdiv++4am1+vngq
         cHZW06OEj1FkyUC+8daB0bcPWC5Uo74Dox1TPYILxhC5dXz94a+nt8pkA0Ulo288EV
         8L5Gg+KTJF2FOK+UhKHqf9/TUIftE16bJ+CPpY9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <benh@debian.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 234/365] tools/rtla: Fix command symlinks
Date:   Tue, 23 Aug 2022 10:02:15 +0200
Message-Id: <20220823080128.020429824@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <benh@debian.org>

commit ff5a55dcdb343e3db9b9fb08795b78544b032773 upstream.

"ln -s" stores the next argument directly as the symlink target, so
it needs to be a relative path.  In this case, just "rtla".

Link: https://lore.kernel.org/linux-trace-devel/YtLBXMI6Ui4HLIF1@decadent.org.uk

Fixes: 0605bf009f18 ("rtla: Add osnoise tool")
Fixes: a828cd18bc4a ("rtla: Add timerlat tool and timelart top mode")
Signed-off-by: Ben Hutchings <benh@debian.org>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 1bea2d16d4c1..b8fe10d941ce 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -108,9 +108,9 @@ install: doc_install
 	$(INSTALL) rtla -m 755 $(DESTDIR)$(BINDIR)
 	$(STRIP) $(DESTDIR)$(BINDIR)/rtla
 	@test ! -f $(DESTDIR)$(BINDIR)/osnoise || rm $(DESTDIR)$(BINDIR)/osnoise
-	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/osnoise
+	ln -s rtla $(DESTDIR)$(BINDIR)/osnoise
 	@test ! -f $(DESTDIR)$(BINDIR)/timerlat || rm $(DESTDIR)$(BINDIR)/timerlat
-	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/timerlat
+	ln -s rtla $(DESTDIR)$(BINDIR)/timerlat
 
 .PHONY: clean tarball
 clean: doc_clean
-- 
2.37.2



