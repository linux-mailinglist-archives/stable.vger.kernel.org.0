Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0D4F3012
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356239AbiDEKXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiDEJau (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D31A48E55;
        Tue,  5 Apr 2022 02:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5236164D;
        Tue,  5 Apr 2022 09:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FAEC385A2;
        Tue,  5 Apr 2022 09:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150279;
        bh=nlm8p+tTQwhGjPD/lcR+yMaGdpDQ15VBJt2fFe08qzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGPnw2wW3+9wOoH4inwMEo3sosdHxPVt/r9scUAnOdSgTjkzWWKIbUFpL8sDaLPyI
         JqJRIGpe05fjQPTK2MWQ6DkhBPBWpFgjSD7y4klsyLgNiUTn04h9moNRh1Q4aHHwzn
         9Yl7mllGrVG/6Ya9wqzSmOlpN1Ld6A9QgBa3pgVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.16 1002/1017] um: Fix uml_mconsole stop/go
Date:   Tue,  5 Apr 2022 09:31:55 +0200
Message-Id: <20220405070423.943692936@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

commit 1a3a6a2a035bb6c3a7ef4c788d8fd69a7b2d6284 upstream.

Moving to an EPOLL based IRQ controller broke uml_mconsole stop/go
commands. This fixes it and restores stop/go functionality.

Fixes: ff6a17989c08 ("Epoll based IRQ controller")
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/mconsole_kern.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -224,7 +224,7 @@ void mconsole_go(struct mc_request *req)
 
 void mconsole_stop(struct mc_request *req)
 {
-	deactivate_fd(req->originating_fd, MCONSOLE_IRQ);
+	block_signals();
 	os_set_fd_block(req->originating_fd, 1);
 	mconsole_reply(req, "stopped", 0, 0);
 	for (;;) {
@@ -247,6 +247,7 @@ void mconsole_stop(struct mc_request *re
 	}
 	os_set_fd_block(req->originating_fd, 0);
 	mconsole_reply(req, "", 0, 0);
+	unblock_signals();
 }
 
 static DEFINE_SPINLOCK(mc_devices_lock);


