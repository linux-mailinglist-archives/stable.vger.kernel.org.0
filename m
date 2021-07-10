Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEB63C3176
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhGJCl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235813AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D52161431;
        Sat, 10 Jul 2021 02:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884572;
        bh=YBbsfupXMjTT6ifevQa5TsXdZ6/h/HIV/MLtHSlXhUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wt1ne4q9poLvjDdDgdx6FTgn6C5duy8+Ku+iO9DjR5sAr8SCdz9dieYDJ6I2TFKCO
         //6XylwQhBmbb6s33M7u96mCnHOh0bkKTKbL/Xv/eNb45x60HztLUglag+DBJUZc6R
         8HY1yspAj59532ZG9OXJ39L5F4Fbc3DWT6hfIYO9K0bn4rx8BNVvHGyKHJZ0xSOl61
         voSyCSHs6vI1L8DDldA6fgt2cFB6ERkn+b0vmWK59TPZHTgweKpMA/OBkQSvizUct0
         cAj3GjtCMppx8vOGBqd6M9Bx13F0NlhiR/JkIRxW7uwErHdweBIMI3eEs2TR9Qebcl
         +sqUVkiytq0bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/26] tty: serial: 8250: serial_cs: Fix a memory leak in error handling path
Date:   Fri,  9 Jul 2021 22:35:44 -0400
Message-Id: <20210710023604.3172486-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit fad92b11047a748c996ebd6cfb164a63814eeb2e ]

In the probe function, if the final 'serial_config()' fails, 'info' is
leaking.

Add a resource handling path to free this memory.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/dc25f96b7faebf42e60fe8d02963c941cf4d8124.1621971720.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/serial_cs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 8106353ce7aa..38e8045a36cc 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -305,6 +305,7 @@ static int serial_resume(struct pcmcia_device *link)
 static int serial_probe(struct pcmcia_device *link)
 {
 	struct serial_info *info;
+	int ret;
 
 	dev_dbg(&link->dev, "serial_attach()\n");
 
@@ -319,7 +320,15 @@ static int serial_probe(struct pcmcia_device *link)
 	if (do_sound)
 		link->config_flags |= CONF_ENABLE_SPKR;
 
-	return serial_config(link);
+	ret = serial_config(link);
+	if (ret)
+		goto free_info;
+
+	return 0;
+
+free_info:
+	kfree(info);
+	return ret;
 }
 
 static void serial_detach(struct pcmcia_device *link)
-- 
2.30.2

