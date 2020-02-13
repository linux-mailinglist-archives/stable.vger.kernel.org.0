Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C2215C304
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgBMPjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:39:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbgBMP3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:05 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7AF24696;
        Thu, 13 Feb 2020 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607744;
        bh=xBa2u05UtOgzy/5qyklWzIFc0OBcGSMN3eKwOCuZ6lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/V6C+ohi2XjAZq4ymrb26gdMUpocjMk4zciE81cU/UundoR+m2u1N8cWkHXxEsBZ
         zLBCV/z9j0oRBhirx7LDZkGSzJ+9x3NIhKjLEp2AYxnMdIrNN+GiqStZTT3jURWRyD
         4Nszf1QyewS/IGWYrk+5VtufLavwnKK+twEQmjV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akshu Agrawal <akshu.agrawal@amd.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.5 101/120] i2c: cros-ec-tunnel: Fix slave device enumeration
Date:   Thu, 13 Feb 2020 07:21:37 -0800
Message-Id: <20200213151934.867199556@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akshu Agrawal <akshu.agrawal@amd.com>

commit 8ff2d7ca4a55dfabf12e876369835bd024eb4621 upstream.

During adding of the adapter the slave device registration
use to fail as the acpi companion field was not populated.

Fixes: 9af1563a5486 ("i2c: cros-ec-tunnel: Make the device acpi compatible")
Signed-off-by: Akshu Agrawal <akshu.agrawal@amd.com>
Acked-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-cros-ec-tunnel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -273,6 +273,7 @@ static int ec_i2c_probe(struct platform_
 	bus->adap.dev.parent = &pdev->dev;
 	bus->adap.dev.of_node = pdev->dev.of_node;
 	bus->adap.retries = I2C_MAX_RETRIES;
+	ACPI_COMPANION_SET(&bus->adap.dev, ACPI_COMPANION(&pdev->dev));
 
 	err = i2c_add_adapter(&bus->adap);
 	if (err)


