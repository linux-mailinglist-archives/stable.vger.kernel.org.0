Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9027C440
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgI2LMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgI2LMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6822C21941;
        Tue, 29 Sep 2020 11:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377921;
        bh=YBtr1W8K5aODUAYWKFY6BuNG3LLxlaIYNmpyj7AhO+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NC9//kh1aEI285iZkJPOLXDDlelhjIT0qBEqnPCJ2ryQiDgygtUCbg+R80vlbkU3+
         WMSLkTxspcvMuKOthmXgzhEqtJ2d240BpNcOpJjitrRy1s8EPM79QVUcaM6Q5oJ7CS
         FrYqeAWp5nvWAb6BFR68aACQB+Ffnu/SHwAuva3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shreyas Joshi <shreyas.joshi@biamp.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 090/121] printk: handle blank console arguments passed in.
Date:   Tue, 29 Sep 2020 13:00:34 +0200
Message-Id: <20200929105934.639060548@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyas Joshi <shreyas.joshi@biamp.com>

[ Upstream commit 48021f98130880dd74286459a1ef48b5e9bc374f ]

If uboot passes a blank string to console_setup then it results in
a trashed memory. Ultimately, the kernel crashes during freeing up
the memory.

This fix checks if there is a blank parameter being
passed to console_setup from uboot. In case it detects that
the console parameter is blank then it doesn't setup the serial
device and it gracefully exits.

Link: https://lore.kernel.org/r/20200522065306.83-1-shreyas.joshi@biamp.com
Signed-off-by: Shreyas Joshi <shreyas.joshi@biamp.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
[pmladek@suse.com: Better format the commit message and code, remove unnecessary brackets.]
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c1873d325ebda..7acae2f2478d9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2035,6 +2035,9 @@ static int __init console_setup(char *str)
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
+	if (str[0] == 0)
+		return 1;
+
 	if (_braille_console_setup(&str, &brl_options))
 		return 1;
 
-- 
2.25.1



