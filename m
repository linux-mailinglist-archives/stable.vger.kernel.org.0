Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEE63CA89E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241411AbhGOTBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241663AbhGOTBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09830613DA;
        Thu, 15 Jul 2021 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375468;
        bh=UcI2nQ0dRPY6zF58aNhzWINc4a8QNy6Vta0vXQPrW2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTZmdzt74BKfTRG9PQ0JiKl9mPicggxN9npGdjs5tx/yMEWBNYlARz5qHVL0mEiqO
         5CbZcd/7k06aI/5j2xwtS9TZdhci98w4PpdbIW/SDI/dcW7lu3m8pc2F7EvdpwkJm3
         QkqkSE2+p+kINsNv8iHrgHevLJasDcoJV+UaPm4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 099/242] net: ipa: Add missing of_node_put() in ipa_firmware_load()
Date:   Thu, 15 Jul 2021 20:37:41 +0200
Message-Id: <20210715182610.491621107@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
index 97c1b55405cb..ba27bcde901e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -679,6 +679,7 @@ static int ipa_firmware_load(struct device *dev)
 	}
 
 	ret = of_address_to_resource(node, 0, &res);
+	of_node_put(node);
 	if (ret) {
 		dev_err(dev, "error %d getting \"memory-region\" resource\n",
 			ret);
-- 
2.30.2



