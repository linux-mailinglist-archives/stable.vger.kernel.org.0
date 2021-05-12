Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847B837C7C1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhELQCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238182AbhELP53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD24F61C27;
        Wed, 12 May 2021 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833443;
        bh=xlLUq19/W7mJfH+7izPsFzsIiqBv7Nf50kslBfS5AGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQcQpOtzo8co/xwDbufC0gr4khY6nWnaYblCc26FstczepbosvRBRK2sf25thSy8F
         cxojuaUeuOe5BeMeaI62CbFXdytjrf7QherkaG/aPt0UOxnGnPp76JvSZBfUU3rWiw
         11pcPdg/tniGT/41iHmMdG0+IQ9w2ZQbbK8aQh9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 153/601] serial: liteuart: fix return value check in liteuart_probe()
Date:   Wed, 12 May 2021 16:43:50 +0200
Message-Id: <20210512144832.853802609@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit cebeddd6d0d9f839b9df2930b6a768b54913a763 ]

In case of error, the function devm_platform_get_and_ioremap_resource()
returns ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210305034929.3234352-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/liteuart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
index 64842f3539e1..0b06770642cb 100644
--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -270,8 +270,8 @@ static int liteuart_probe(struct platform_device *pdev)
 
 	/* get membase */
 	port->membase = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (!port->membase)
-		return -ENXIO;
+	if (IS_ERR(port->membase))
+		return PTR_ERR(port->membase);
 
 	/* values not from device tree */
 	port->dev = &pdev->dev;
-- 
2.30.2



