Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7112064FA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbgFWUOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389173AbgFWUON (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:14:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E7B0206C3;
        Tue, 23 Jun 2020 20:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943253;
        bh=CI/oGavi/bq5wi1BOBYdG88726vRh1bRqOK1/ZmRX0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4/C/pJrt2p8MRBxiQr7aZhvNI8vKBJFOkrF4mYEQUUL4WCy6cnEERRkjKPgN4yti
         IBR/oTg0PeZ7lChitK7epvJ6O7Ljf7vQ91kgH4wYTiXsvzbToaLxZSEkVbxF6MVCtF
         C22+t8pAQvUX75VBc+890eZwZGGJmCBk22nSrDSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 302/477] rtc: rv3028: Add missed check for devm_regmap_init_i2c()
Date:   Tue, 23 Jun 2020 21:54:59 +0200
Message-Id: <20200623195421.824837236@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit c3b29bf6f166f6ed5f04f9c125477358e0e25df8 ]

rv3028_probe() misses a check for devm_regmap_init_i2c().
Add the missed check to fix it.

Fixes: e6e7376cfd7b ("rtc: rv3028: add new driver")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200528103950.912353-1-hslester96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3028.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-rv3028.c b/drivers/rtc/rtc-rv3028.c
index a0ddc86c975a4..ec84db0b3d7ab 100644
--- a/drivers/rtc/rtc-rv3028.c
+++ b/drivers/rtc/rtc-rv3028.c
@@ -755,6 +755,8 @@ static int rv3028_probe(struct i2c_client *client)
 		return -ENOMEM;
 
 	rv3028->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(rv3028->regmap))
+		return PTR_ERR(rv3028->regmap);
 
 	i2c_set_clientdata(client, rv3028);
 
-- 
2.25.1



