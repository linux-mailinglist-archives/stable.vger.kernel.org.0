Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B6B1D8286
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgERR5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731740AbgERR5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87E8D20674;
        Mon, 18 May 2020 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824630;
        bh=VFi5CkaO2DwUtxZQxQco5fy/+XpBrOt7pEBYtSTIFN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpjnUJrie9Yj4ZGxksoZZ8i7o+w1jNojpnsaHgKkCR5j9R3nt2zcDTvDl2WC/guD8
         TfVWzWCO3wlOIISa0f1mDJZIuc+bxp0gR9HHKthM9F8DhnuNrMgZ/D0ctQCIEUZGVP
         DZH0Jp4nbana3+8jLJFrhnLcTxDsUAACnHKEvgsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samu Nuutamo <samu.nuutamo@vincit.fi>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/147] hwmon: (da9052) Synchronize access with mfd
Date:   Mon, 18 May 2020 19:36:52 +0200
Message-Id: <20200518173524.639851373@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samu Nuutamo <samu.nuutamo@vincit.fi>

[ Upstream commit 333e22db228f0bd0c839553015a6a8d3db4ba569 ]

When tsi-as-adc is configured it is possible for in7[0123]_input read to
return an incorrect value if a concurrent read to in[456]_input is
performed. This is caused by a concurrent manipulation of the mux
channel without proper locking as hwmon and mfd use different locks for
synchronization.

Switch hwmon to use the same lock as mfd when accessing the TSI channel.

Fixes: 4f16cab19a3d5 ("hwmon: da9052: Add support for TSI channel")
Signed-off-by: Samu Nuutamo <samu.nuutamo@vincit.fi>
[rebase to current master, reword commit message slightly]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/da9052-hwmon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index 53b517dbe7e6e..4af2fc309c286 100644
--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -244,9 +244,9 @@ static ssize_t da9052_tsi_show(struct device *dev,
 	int channel = to_sensor_dev_attr(devattr)->index;
 	int ret;
 
-	mutex_lock(&hwmon->hwmon_lock);
+	mutex_lock(&hwmon->da9052->auxadc_lock);
 	ret = __da9052_read_tsi(dev, channel);
-	mutex_unlock(&hwmon->hwmon_lock);
+	mutex_unlock(&hwmon->da9052->auxadc_lock);
 
 	if (ret < 0)
 		return ret;
-- 
2.20.1



