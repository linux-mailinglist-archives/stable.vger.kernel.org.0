Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E21E3CAA73
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241445AbhGOTNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242654AbhGOTLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695E96127C;
        Thu, 15 Jul 2021 19:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376091;
        bh=bEqreD9VTjWWjfTR+aT3nMLJCs0WPTRmFE93Xib2xwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHrZUkSOJnCE4qaLd0lZBNrIFCJyIBqfmB5IRwKnQ7ZQu5L5A/9RqooKZ4jhCTIef
         JgrXaWDC9wXkV2T7LJDRmNB35PZmcctLZTsJGaeoyZEmsihkhVmq0CUyNbt/XCj57x
         Q1l4GuBeqH0vDXWb+AuJHN/2piKXu8K7Mn0qcZ5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 116/266] net: ipa: Add missing of_node_put() in ipa_firmware_load()
Date:   Thu, 15 Jul 2021 20:37:51 +0200
Message-Id: <20210715182634.367245495@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b244163f2c45c12053cb0291c955f892e79ed8a9 ]

This node pointer is returned by of_parse_phandle() with refcount
incremented in this function. of_node_put() on it before exiting
this function.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9915603ed10b..c4ad5f20496e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -529,6 +529,7 @@ static int ipa_firmware_load(struct device *dev)
 	}
 
 	ret = of_address_to_resource(node, 0, &res);
+	of_node_put(node);
 	if (ret) {
 		dev_err(dev, "error %d getting \"memory-region\" resource\n",
 			ret);
-- 
2.30.2



