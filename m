Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6A96B4275
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjCJODl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjCJODK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E499424713
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:03:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 816806182F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE65C433A0;
        Fri, 10 Mar 2023 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456987;
        bh=gMVmOxEg0kG8TXM4Vu1EEI9zczKzCBnsDJYRDRaoARQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D67hAukDB9BxhNDjbm9uLHdskWClryY4wPiI0IH7tk2CUz6lnHI3JqV6eYV3zRGXJ
         3pwVbezDkvGFo3g0WtIzRXJNr8DCQRpon16BMgUxUnOCTvLhTc6r360cTfNwgcMv3I
         fYYDPupX1q0T4qRgoCgnKiGso2dEFhCtTkQ5oxlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 176/211] tty: pcn_uart: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:16 +0100
Message-Id: <20230310133724.170654347@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 9576ba8bbc40e..cc83b772b7ca9 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1775,7 +1775,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	char name[32];
 
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
-	debugfs_remove(debugfs_lookup(name, NULL));
+	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
 	free_page((unsigned long)priv->rxbuf.buf);
 }
-- 
2.39.2



