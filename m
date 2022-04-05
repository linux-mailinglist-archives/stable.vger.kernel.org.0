Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99E24F30FA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244569AbiDEJyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244102AbiDEJOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69D73DDF6;
        Tue,  5 Apr 2022 02:00:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52797B818F3;
        Tue,  5 Apr 2022 09:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D611C385A0;
        Tue,  5 Apr 2022 09:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149236;
        bh=ROnrbzz1l46AppRuRx0ztfxHB96FsZrQXsAc4TedgXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hu4hLyKGP5TGp0UbFMQf5fyb6XZA4huXEUSByB/m7A+67gG/S8uw6TXscTIXPZNMn
         8WLyiOFgCWv6Oo0ralos1Kxt6rBirc4QiwjWWk9DhDncKFFDUdayLGCZrhHtsCOcap
         qcPNiX5H8f7jm/tE/sMaLBO9nVhd0Ktj3iM5AEk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0644/1017] mxser: fix xmit_buf leak in activate when LSR == 0xff
Date:   Tue,  5 Apr 2022 09:25:57 +0200
Message-Id: <20220405070413.399273841@linuxfoundation.org>
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
index 39458b42df7b..88d2f16fbf89 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -719,6 +719,7 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 	struct mxser_port *info = container_of(port, struct mxser_port, port);
 	unsigned long page;
 	unsigned long flags;
+	int ret;
 
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
@@ -728,9 +729,9 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 
 	if (!info->type) {
 		set_bit(TTY_IO_ERROR, &tty->flags);
-		free_page(page);
 		spin_unlock_irqrestore(&info->slock, flags);
-		return 0;
+		ret = 0;
+		goto err_free_xmit;
 	}
 	info->port.xmit_buf = (unsigned char *) page;
 
@@ -750,8 +751,10 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
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
@@ -796,6 +799,10 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
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



