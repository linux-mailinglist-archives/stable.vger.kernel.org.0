Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F1A548F90
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiFMKZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343705AbiFMKY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC3123BEB;
        Mon, 13 Jun 2022 03:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB6E760B8D;
        Mon, 13 Jun 2022 10:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A7AC3411C;
        Mon, 13 Jun 2022 10:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115564;
        bh=EsMgRyH2Ui3b8N69KMl1Dg6EPahzTTOTDN582z6MPe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2EKXT2Vz111GNO0zUJW823LX+CZ7lUhZsOv0JIIMevdVMhqSMBmSO316jtKb+I3F
         QSezoYT1iohTqzl6es6SeNTsK4CkqGZ1xArmJbmv30zcKVuRDbDrXgMxkwlRnAYiTw
         NCyNyuJCEhkKe46NFoYTCaDjo/aIZi2OfucTFfDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 119/167] serial: sh-sci: Dont allow CS5-6
Date:   Mon, 13 Jun 2022 12:09:53 +0200
Message-Id: <20220613094908.655412139@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 9b87162de8be26bf3156460b37deee6399fd0fcb ]

Only CS7 and CS8 seem supported but CSIZE is not sanitized from
CS5 or CS6 to CS8.

Set CSIZE correctly so that userspace knows the effective value.
Incorrect CSIZE also results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Fixes: 1da177e4c3f4 (Linux-2.6.12-rc2)
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-6-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 5c6243a31166..91c69fc3987a 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2206,8 +2206,12 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned long max_freq = 0;
 	int best_clk = -1;
 
-	if ((termios->c_cflag & CSIZE) == CS7)
+	if ((termios->c_cflag & CSIZE) == CS7) {
 		smr_val |= SCSMR_CHR;
+	} else {
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
+	}
 	if (termios->c_cflag & PARENB)
 		smr_val |= SCSMR_PE;
 	if (termios->c_cflag & PARODD)
-- 
2.35.1



