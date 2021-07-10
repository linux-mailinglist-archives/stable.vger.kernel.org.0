Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52893C2DEE
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhGJCZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhGJCZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5226613CC;
        Sat, 10 Jul 2021 02:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883756;
        bh=jpeVSUEUTVSAs5B0cP6g1fCG9vedipyGLpx+i1vy83Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AP0WJhtmoOKToaPwOk5t6MRYBDRLDBZxU8sCVpNccqiMTAFDR+agVjUVrsxfOH/AL
         7QTxGSdYJn8UkgayHcJwgm6tRwWg5KExjqlOku2+Qpw1u1tzoIthFlxMe+NDqIcUlO
         TvLR5KwuBrxOruSuCMYN3+J3j+ZuMsKXZ73V4cSqmxvIzlr4ofzgcZKHXvFVGhxTTM
         /mH7vUoMxB1SKiN6G+ZaAECM1hPreXhZvGuDjpOVM8oJ0IpugM2K38f5qYS9W4EPlc
         y8Aez4QPSc6wX34q9zxWLGy5O7XohRMezq5KN3KfognudAZbYWG1IEn840ooI+EMCs
         +tV34nzeYL9+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 031/104] tty: serial: 8250: serial_cs: Fix a memory leak in error handling path
Date:   Fri,  9 Jul 2021 22:20:43 -0400
Message-Id: <20210710022156.3168825-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 35ff6627c61b..2cd2acc09cc4 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -306,6 +306,7 @@ static int serial_resume(struct pcmcia_device *link)
 static int serial_probe(struct pcmcia_device *link)
 {
 	struct serial_info *info;
+	int ret;
 
 	dev_dbg(&link->dev, "serial_attach()\n");
 
@@ -320,7 +321,15 @@ static int serial_probe(struct pcmcia_device *link)
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

