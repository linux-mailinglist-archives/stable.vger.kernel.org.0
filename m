Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B64505626
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242095AbiDRNcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiDRNa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171301EC54;
        Mon, 18 Apr 2022 05:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7157612BB;
        Mon, 18 Apr 2022 12:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B004CC385A7;
        Mon, 18 Apr 2022 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286550;
        bh=XH/Kan+cTZtZrlbEHeit+4DII2CBsZqniMAz6XbgDrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLS/M0IXsRd17B/y5sNL+NioWcHlvO0o52HHeH40WUikxWdeLMosS9lp9MpsA4JEL
         oQiq1i24O1MUCBlg10CSwZqQ/yLZo1GxkNCgu4I3KSugMecFFZqnTbGSiKEWtwgfDz
         lwxt44ukcYsaUy3abxjz3MbpWRNfu6YF0oZp5iVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/284] mxser: fix xmit_buf leak in activate when LSR == 0xff
Date:   Mon, 18 Apr 2022 14:11:50 +0200
Message-Id: <20220418121214.940474839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit cd3a4907ee334b40d7aa880c7ab310b154fd5cd4 ]

When LSR is 0xff in ->activate() (rather unlike), we return an error.
Provided ->shutdown() is not called when ->activate() fails, nothing
actually frees the buffer in this case.

Fix this by properly freeing the buffer in a designated label. We jump
there also from the "!info->type" if now too.

Fixes: 6769140d3047 ("tty: mxser: use the tty_port_open method")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220124071430.14907-6-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/mxser.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 7dd38047ba23..31d5a4d95c2d 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -866,6 +866,7 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 	struct mxser_port *info = container_of(port, struct mxser_port, port);
 	unsigned long page;
 	unsigned long flags;
+	int ret;
 
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
@@ -875,9 +876,9 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 
 	if (!info->ioaddr || !info->type) {
 		set_bit(TTY_IO_ERROR, &tty->flags);
-		free_page(page);
 		spin_unlock_irqrestore(&info->slock, flags);
-		return 0;
+		ret = 0;
+		goto err_free_xmit;
 	}
 	info->port.xmit_buf = (unsigned char *) page;
 
@@ -903,8 +904,10 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 		if (capable(CAP_SYS_ADMIN)) {
 			set_bit(TTY_IO_ERROR, &tty->flags);
 			return 0;
-		} else
-			return -ENODEV;
+		}
+
+		ret = -ENODEV;
+		goto err_free_xmit;
 	}
 
 	/*
@@ -949,6 +952,10 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 	spin_unlock_irqrestore(&info->slock, flags);
 
 	return 0;
+err_free_xmit:
+	free_page(page);
+	info->port.xmit_buf = NULL;
+	return ret;
 }
 
 /*
-- 
2.34.1



