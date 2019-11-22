Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2969F106C11
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfKVKtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbfKVKte (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:49:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C7592071F;
        Fri, 22 Nov 2019 10:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419774;
        bh=km4X5vKqo7Inc5aIAMHNteD9crBieiW9GgVbiAH/MyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3ddhxlwpb5r1bBnWow9Wp+OVZRuFaWJi608c09qRzKjJFsIUUW2+WmSfqeQ5PAMT
         HR+W1JeD7XMT0xDKHYMSyKMvmN8G1u43k+BGAJ+301qltLVyANHUSo/QACPE4xFAVC
         gOmW58vCohekyzrGfDQEm0UvDAY3KLLcfwOu9gEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 217/222] hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros
Date:   Fri, 22 Nov 2019 11:29:17 +0100
Message-Id: <20191122100918.207823796@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolin Chen <nicoleotsuka@gmail.com>

[ Upstream commit 791ebc9d34e9d212fc03742c31654b017d385926 ]

The three INA3221_CONFIG_MODE macros are not correctly defined here.
The MODE3-1 bits are located at BIT 2-0 according to the datasheet.

So this patch just fixes them by shifting all of them with a correct
offset. However, this isn't a crital bug fix as the driver does not
use any of them at this point.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina3221.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index e6b49500c52ae..8c9555313fc3d 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -38,9 +38,9 @@
 #define INA3221_WARN3			0x0c
 #define INA3221_MASK_ENABLE		0x0f
 
-#define INA3221_CONFIG_MODE_SHUNT	BIT(1)
-#define INA3221_CONFIG_MODE_BUS		BIT(2)
-#define INA3221_CONFIG_MODE_CONTINUOUS	BIT(3)
+#define INA3221_CONFIG_MODE_SHUNT	BIT(0)
+#define INA3221_CONFIG_MODE_BUS		BIT(1)
+#define INA3221_CONFIG_MODE_CONTINUOUS	BIT(2)
 
 #define INA3221_RSHUNT_DEFAULT		10000
 
-- 
2.20.1



