Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C962C9BFB
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbgLAJNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390158AbgLAJNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA97C221FD;
        Tue,  1 Dec 2020 09:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813987;
        bh=tDeKhy4Ja2H7eQ9JtPqG9LWEKq3Lr5meVQCI1lW2YdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiODEa1EWQFvY1ZTp9vFrnSf53nvaMHlmwyr5ySLcDhDCKER09ktW/0vbTrvNzY39
         4QRRH5WNYqiRau0d8q8msr+CJ1KkeipJYZtDaMqsNQLJ01jFoTjEVHHmpSArffaETk
         j3CHjQpiV6kLAPiiLYpSyivzU2ttWDJ+AxxAJM6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 110/152] nfc: s3fwrn5: use signed integer for parsing GPIO numbers
Date:   Tue,  1 Dec 2020 09:53:45 +0100
Message-Id: <20201201084726.265251952@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit d8f0a86795c69f5b697f7d9e5274c124da93c92d ]

GPIOs - as returned by of_get_named_gpio() and used by the gpiolib - are
signed integers, where negative number indicates error.  The return
value of of_get_named_gpio() should not be assigned to an unsigned int
because in case of !CONFIG_GPIOLIB such number would be a valid GPIO.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201123162351.209100-1-krzk@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index b4eb926d220ac..d7ecff0b1c662 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -26,8 +26,8 @@ struct s3fwrn5_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nci_dev *ndev;
 
-	unsigned int gpio_en;
-	unsigned int gpio_fw_wake;
+	int gpio_en;
+	int gpio_fw_wake;
 
 	struct mutex mutex;
 
-- 
2.27.0



