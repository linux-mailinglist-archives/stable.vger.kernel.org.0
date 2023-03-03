Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC96AA313
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjCCVyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjCCVxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:53:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C9570425;
        Fri,  3 Mar 2023 13:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 406DF6194F;
        Fri,  3 Mar 2023 21:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AC7C433A1;
        Fri,  3 Mar 2023 21:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880017;
        bh=qY1rAG7JheThVW8xBvdHEHilnkXi1PIGV37rHVyJs2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy9QcND8GTJoehumkHcPbXW+v97KQOw5rPn8aSX+zxRFOQp/nea5T06+m7df3Oiwq
         lP44XLlkgF1IgHhe7X+fzXK0SqYlQe9Ua5JUGoscg0Nah7kE2/PM77IUhvzXYrjuw/
         tQA6S328/27DSXGcVMIhbl+gEvbFXLw+T0GNWUMov4SbNrVwij+rIFy9yzBNYX0E35
         cbBvqmXEKAF2eBFXVRVgzFVRfKgxeHGbVudkXMGq2hn77oaHOR98Bc3TbZOHT1kjNs
         FyjDjSOs9w+9Pz4bWr1/gvdHP7PsPEv6mwdT55A3FLSTmlR2/gv85I1uTUMqeSE+UU
         nLhWOn1luxLpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 39/50] tty: pcn_uart: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:20 -0500
Message-Id: <20230303214531.1450154-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

