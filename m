Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F662F691
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbfE3E5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbfE3DJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:54 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E81A12447B;
        Thu, 30 May 2019 03:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185794;
        bh=aFulq45jcbmOE+rmTiPFUcS+ut7sv6MMNvhjK8ujpNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbNAfI3dz90hZq9zqUd9HT7HcpKDltpebiB3+KlZV4sechz1bC9qYXL14zQj2aed0
         M30Z8IESM0WvjO68tGPWLSQfhDZSo+uRfQY1fGUULva8htdhRCrJAEKdcA0kKl2JpM
         Y7jMCYi06uvAfY0L+XCJL2B13noTf/MeEYMkz7MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jun Nie <jun.nie@linaro.org>, linux-gpio@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 068/405] pinctrl: zte: fix leaked of_node references
Date:   Wed, 29 May 2019 20:01:06 -0700
Message-Id: <20190530030544.374403462@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 02d15f0d80720545f1f4922a1550ea4aaad4e152 ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/pinctrl/zte/pinctrl-zx.c:415:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 407, but without a corresponding object release within this function.
./drivers/pinctrl/zte/pinctrl-zx.c:422:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 407, but without a corresponding object release within this function.
./drivers/pinctrl/zte/pinctrl-zx.c:436:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 407, but without a corresponding object release within this function.
./drivers/pinctrl/zte/pinctrl-zx.c:444:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 407, but without a corresponding object release within this function.
./drivers/pinctrl/zte/pinctrl-zx.c:448:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 407, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jun Nie <jun.nie@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/zte/pinctrl-zx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/zte/pinctrl-zx.c b/drivers/pinctrl/zte/pinctrl-zx.c
index caa44dd2880a8..3cb69309912ba 100644
--- a/drivers/pinctrl/zte/pinctrl-zx.c
+++ b/drivers/pinctrl/zte/pinctrl-zx.c
@@ -411,6 +411,7 @@ int zx_pinctrl_init(struct platform_device *pdev,
 	}
 
 	zpctl->aux_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!zpctl->aux_base)
 		return -ENOMEM;
 
-- 
2.20.1



