Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A490A14B860
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgA1OWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731753AbgA1OWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:22:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CBA24686;
        Tue, 28 Jan 2020 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221373;
        bh=BAuGnV6ApDLBskZlToVXtsrcdU/YeZu3hnzsSO+iKSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdiMJxu+9xgkJ22CLB8TG7ZfHGlVVynwq1sZmzZQDZw58JHaWQWDF1qL6Gs7VdJfc
         hEulzUC1aKSJs7ktm+/U0zkbpRks1PuY+/sc2JrkH0DLsCSwhg5bsFWdBHYdkue7qH
         pKgj8nmKzJaWBdyyBFawl6nZlOAmNSy6Q/NzaJw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Robertson <dan@dlrobertson.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 199/271] hwmon: (shtc1) fix shtc1 and shtw1 id mask
Date:   Tue, 28 Jan 2020 15:05:48 +0100
Message-Id: <20200128135907.392010581@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit fdc7d8e829ec755c5cfb2f5a8d8c0cdfb664f895 ]

Fix an error in the bitmaskfor the shtc1 and shtw1 bitmask used to
retrieve the chip ID from the ID register. See section 5.7 of the shtw1
or shtc1 datasheet for details.

Fixes: 1a539d372edd9832444e7a3daa710c444c014dc9 ("hwmon: add support for Sensirion SHTC1 sensor")
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Link: https://lore.kernel.org/r/20190905014554.21658-3-dan@dlrobertson.com
[groeck: Reordered to be first in series and adjusted accordingly]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/shtc1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
index decd7df995abf..2a18539591eaf 100644
--- a/drivers/hwmon/shtc1.c
+++ b/drivers/hwmon/shtc1.c
@@ -38,7 +38,7 @@ static const unsigned char shtc1_cmd_read_id_reg[]	       = { 0xef, 0xc8 };
 
 /* constants for reading the ID register */
 #define SHTC1_ID	  0x07
-#define SHTC1_ID_REG_MASK 0x1f
+#define SHTC1_ID_REG_MASK 0x3f
 
 /* delays for non-blocking i2c commands, both in us */
 #define SHTC1_NONBLOCKING_WAIT_TIME_HPM  14400
-- 
2.20.1



