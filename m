Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2491437CBE8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbhELQiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236253AbhELQ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D489261263;
        Wed, 12 May 2021 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834995;
        bh=xlLUq19/W7mJfH+7izPsFzsIiqBv7Nf50kslBfS5AGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdTWrb9nKxx/W0oWtgpHSKC+uBH6nStZvuDvFqnfxb3i4fPSJi/fftKL/iEKg5eDr
         05paoiIE7auD1+Vbwy8dwNGSVjXNhxY1kZnp0dvmB5oV8JZx06huhkLzg4xODA8mtI
         OicuWXa/O0Ek2W/xVHUIuUrFuMJsyz+vdKvBduFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 166/677] serial: liteuart: fix return value check in liteuart_probe()
Date:   Wed, 12 May 2021 16:43:32 +0200
Message-Id: <20210512144842.762763232@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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



