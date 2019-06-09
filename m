Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887623A864
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbfFIRAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733060AbfFIRAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62015208C0;
        Sun,  9 Jun 2019 17:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099605;
        bh=/S59m0CzpcjCSiQrTxnr1llmebHj+C0q8Wm5C6GKvZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWZluH0VDlRiUC8bZqC68dK1GXMH0U1zjg1bB03+TLrQetGXYauMm+xuO9REi2iT7
         bsKyalAdpgfKmZaDAxnE1tfeFzNMcIbpL/T7psiJFDM//gx2YDx2xV8UjhgQXDtm2f
         2vqAT4TywR8TDWG1MXPFi5fWTdtTF8NlC6KXsNTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mariusz Bialonczyk <manio@skyboo.net>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 101/241] w1: fix the resume command API
Date:   Sun,  9 Jun 2019 18:40:43 +0200
Message-Id: <20190609164150.710401945@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62909da8aca048ecf9fbd7e484e5100608f40a63 ]

>From the DS2408 datasheet [1]:
"Resume Command function checks the status of the RC flag and, if it is set,
 directly transfers control to the control functions, similar to a Skip ROM
 command. The only way to set the RC flag is through successfully executing
 the Match ROM, Search ROM, Conditional Search ROM, or Overdrive-Match ROM
 command"

The function currently works perfectly fine in a multidrop bus, but when we
have only a single slave connected, then only a Skip ROM is used and Match
ROM is not called at all. This is leading to problems e.g. with single one
DS2408 connected, as the Resume Command is not working properly and the
device is responding with failing results after the Resume Command.

This commit is fixing this by using a Skip ROM instead in those cases.
The bandwidth / performance advantage is exactly the same.

Refs:
[1] https://datasheets.maximintegrated.com/en/ds/DS2408.pdf

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
Reviewed-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 282092421cc9e..1a9d9ec8db4df 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -437,8 +437,7 @@ int w1_reset_resume_command(struct w1_master *dev)
 	if (w1_reset_bus(dev))
 		return -1;
 
-	/* This will make only the last matched slave perform a skip ROM. */
-	w1_write_8(dev, W1_RESUME_CMD);
+	w1_write_8(dev, dev->slave_count > 1 ? W1_RESUME_CMD : W1_SKIP_ROM);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(w1_reset_resume_command);
-- 
2.20.1



