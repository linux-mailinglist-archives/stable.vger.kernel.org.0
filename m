Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352895015AA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348280AbiDNOEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346518AbiDNN52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911CE7F224;
        Thu, 14 Apr 2022 06:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46212B82986;
        Thu, 14 Apr 2022 13:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A5EC385A5;
        Thu, 14 Apr 2022 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944014;
        bh=RHNxGL7bcbwJZEtC99Uv4qm7qx/UvaOnhh+E7nDBd/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJU+Knla58A3dpAopwckhUp9sXdjuu1lQxCIIfRClSMXYTIJ25CRNrKr5za1vJGo7
         /rx0MnqoWVPTh4GEoYXtEYbSzIctyg+Gpom1JIzTcTzWPAY0fL1lHNayKP6xtfuN/l
         XrfN+HKRiunGDzwfBpwAK2fXD5C0E6pMaJeB1Q5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 364/475] um: Fix uml_mconsole stop/go
Date:   Thu, 14 Apr 2022 15:12:29 +0200
Message-Id: <20220414110905.266701449@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -217,7 +217,7 @@ void mconsole_go(struct mc_request *req)
 
 void mconsole_stop(struct mc_request *req)
 {
-	deactivate_fd(req->originating_fd, MCONSOLE_IRQ);
+	block_signals();
 	os_set_fd_block(req->originating_fd, 1);
 	mconsole_reply(req, "stopped", 0, 0);
 	for (;;) {
@@ -240,6 +240,7 @@ void mconsole_stop(struct mc_request *re
 	}
 	os_set_fd_block(req->originating_fd, 0);
 	mconsole_reply(req, "", 0, 0);
+	unblock_signals();
 }
 
 static DEFINE_SPINLOCK(mc_devices_lock);


