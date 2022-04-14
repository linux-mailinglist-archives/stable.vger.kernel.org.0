Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088B650152C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244820AbiDNNmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344010AbiDNNaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF6091AD9;
        Thu, 14 Apr 2022 06:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC2FFB82941;
        Thu, 14 Apr 2022 13:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B00FC385A1;
        Thu, 14 Apr 2022 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942762;
        bh=WpbV/kui7UuD8bM1N5stKLj/lbS2sxBNhDGAcSvyodg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTDtUYofVo1oKplaTbnEe2IOfNl8tPHnDdxZ69o1IPG/Ett0e/gLDf+Sqtw8z/ybu
         JTDNv/K9th80L2KXv559GNXX0imFjTrVJZdSHsUuU+DgfZOWP+rNw1kA2fiYsrqfYR
         uvio//SsywvugSape2l7Ikks/yJoNldEM3PY4PAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.19 253/338] um: Fix uml_mconsole stop/go
Date:   Thu, 14 Apr 2022 15:12:36 +0200
Message-Id: <20220414110846.092114486@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
@@ -218,7 +218,7 @@ void mconsole_go(struct mc_request *req)
 
 void mconsole_stop(struct mc_request *req)
 {
-	deactivate_fd(req->originating_fd, MCONSOLE_IRQ);
+	block_signals();
 	os_set_fd_block(req->originating_fd, 1);
 	mconsole_reply(req, "stopped", 0, 0);
 	for (;;) {
@@ -242,6 +242,7 @@ void mconsole_stop(struct mc_request *re
 	os_set_fd_block(req->originating_fd, 0);
 	reactivate_fd(req->originating_fd, MCONSOLE_IRQ);
 	mconsole_reply(req, "", 0, 0);
+	unblock_signals();
 }
 
 static DEFINE_SPINLOCK(mc_devices_lock);


