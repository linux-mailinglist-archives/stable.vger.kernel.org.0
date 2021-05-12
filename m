Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0965137C8E1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhELQNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239282AbhELQHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A129761C59;
        Wed, 12 May 2021 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833830;
        bh=Uxz7oMteSxfFHU48bBX/AmUX+Xv2sHNP8sQl4iLm4c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJVfUGpYomt7T0Vx099b156X35IGuiVZ5paTP2DURE+v1rlcUDxjkjV4NLj7y/865
         UBTPf9I/LwZP3W4L7L+VYd81Qx4OeplzPEC+8lO1eMDSwSaFT/5bJ+pEkSzkQOzpdm
         yq/oxRA6qjiZofs0C1n9AQc2Yl1BRbVREQEplVxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joel Stanley <joel@jms.id.au>,
        Patrick Venture <venture@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 306/601] soc: aspeed: fix a ternary sign expansion bug
Date:   Wed, 12 May 2021 16:46:23 +0200
Message-Id: <20210512144837.896496347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5ffa828534036348fa90fb3079ccc0972d202c4a ]

The intent here was to return negative error codes but it actually
returns positive values.  The problem is that type promotion with
ternary operations is quite complicated.

"ret" is an int.  "copied" is a u32.  And the snoop_file_read() function
returns long.  What happens is that "ret" is cast to u32 and becomes
positive then it's cast to long and it's still positive.

Fix this by removing the ternary so that "ret" is type promoted directly
to long.

Fixes: 3772e5da4454 ("drivers/misc: Aspeed LPC snoop output using misc chardev")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Patrick Venture <venture@google.com>
Link: https://lore.kernel.org/r/YIE90PSXsMTa2Y8n@mwanda
Link: https://lore.kernel.org/r/20210423000919.1249474-1-joel@jms.id.au'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index 20acac6342ef..5828f94b8a7d 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -95,8 +95,10 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
 			return -EINTR;
 	}
 	ret = kfifo_to_user(&chan->fifo, buffer, count, &copied);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static __poll_t snoop_file_poll(struct file *file,
-- 
2.30.2



