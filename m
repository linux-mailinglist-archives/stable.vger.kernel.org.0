Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A00337C424
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhELP3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233872AbhELPXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B9FA615FF;
        Wed, 12 May 2021 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832175;
        bh=SLWMs1rpk2WPhOcuh68j6BUTGqVBRlq2b1IEtVLBjDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhmPoEVIOsX8obamj4dlBjaL5NbfK3/E7adGgfjTRorb9MQn/7spen/1IHojV08CR
         dWyU6u9E5Qal6+HFFWDtdkkm7QW48bYx659c1FSx6U7XlH0HZIQB8h0jUhac2UhYKL
         ytWoIs6SNuBihQMcipPD7uhVialYNIlbNawPEZZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/530] usb: typec: stusb160x: fix return value check in stusb160x_probe()
Date:   Wed, 12 May 2021 16:44:15 +0200
Message-Id: <20210512144824.589975406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f2d90e07b5df2c7745ae66d2d48cc350d3f1c7d2 ]

In case of error, the function device_get_named_child_node() returns
NULL pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Fixes: da0cb6310094 ("usb: typec: add support for STUSB160x Type-C controller family")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210308094839.3586773-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/stusb160x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/stusb160x.c b/drivers/usb/typec/stusb160x.c
index d21750bbbb44..6eaeba9b096e 100644
--- a/drivers/usb/typec/stusb160x.c
+++ b/drivers/usb/typec/stusb160x.c
@@ -682,8 +682,8 @@ static int stusb160x_probe(struct i2c_client *client)
 	}
 
 	fwnode = device_get_named_child_node(chip->dev, "connector");
-	if (IS_ERR(fwnode))
-		return PTR_ERR(fwnode);
+	if (!fwnode)
+		return -ENODEV;
 
 	/*
 	 * When both VDD and VSYS power supplies are present, the low power
-- 
2.30.2



