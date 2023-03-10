Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008646B4AF5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbjCJP2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjCJP2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B474142DC3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC12261A32
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C551CC4339C;
        Fri, 10 Mar 2023 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461368;
        bh=qY1rAG7JheThVW8xBvdHEHilnkXi1PIGV37rHVyJs2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13DM62FNJJIyD7hjFUhm542TeYv5veJMF5uxOHRWPPF1sbsVvTMriy+Ytvi03Mvph
         WbsTQlInCFMvWnU9Uc/XrWP/fM8HuSZjRgxObZU+JApqiS5HIXSdt3dPt6b00NjTl6
         lzWNksP6btDnu8fxd/6MOorHqys9J187UCeynrgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/136] tty: pcn_uart: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:43:56 +0100
Message-Id: <20230310133710.645707319@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 04a189c720aa2b6091442113ce9b9bc93552dff8 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230202141221.2293012-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pch_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 49bc5a4b28327..e783a4225bf04 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1821,7 +1821,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	char name[32];
 
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
-	debugfs_remove(debugfs_lookup(name, NULL));
+	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
 	free_page((unsigned long)priv->rxbuf.buf);
 }
-- 
2.39.2



