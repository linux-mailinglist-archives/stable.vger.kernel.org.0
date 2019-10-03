Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5108DCA52C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403904AbfJCQbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbfJCQbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:31:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D3E421848;
        Thu,  3 Oct 2019 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120306;
        bh=MoJuAFD5H01r8aUKRg6WQ0qWyaX5xkkJmQOMh7mNsM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvDP/r9uNuPZbrh9G+wx0OSzakbytxfCx8a+HOp6ycNFGCtMsSM+vQfu6Sg5suXO9
         z0uFzI6iJ0ezfmlud6TxPM9pl2VWsfivOVF1btJEdEBG/b2XZohaZzKrVX6C2k9TsM
         Vx0o5PLzzizlkDhe7ygn+mxgAgpyrEkmhks1zWGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Shenran <shenran268@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 174/313] hwmon: (acpi_power_meter) Change log level for unsafe software power cap
Date:   Thu,  3 Oct 2019 17:52:32 +0200
Message-Id: <20191003154550.134773235@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Shenran <shenran268@gmail.com>

[ Upstream commit 6e4d91aa071810deac2cd052161aefb376ecf04e ]

At boot time, the acpi_power_meter driver logs the following error level
message: "Ignoring unsafe software power cap". Having read about it from
a few sources, it seems that the error message can be quite misleading.

While the message can imply that Linux is ignoring the fact that the
system is operating in potentially dangerous conditions, the truth is
the driver found an ACPI_PMC object that supports software power
capping. The driver simply decides not to use it, perhaps because it
doesn't support the object.

The best solution is probably changing the log level from error to warning.
All sources I have found, regarding the error, have downplayed its
significance. There is not much of a reason for it to be on error level,
while causing potential confusions or misinterpretations.

Signed-off-by: Wang Shenran <shenran268@gmail.com>
Link: https://lore.kernel.org/r/20190724080110.6952-1-shenran268@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 6ba1a08253f0a..4cf25458f0b95 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -681,8 +681,8 @@ static int setup_attrs(struct acpi_power_meter_resource *resource)
 
 	if (resource->caps.flags & POWER_METER_CAN_CAP) {
 		if (!can_cap_in_hardware()) {
-			dev_err(&resource->acpi_dev->dev,
-				"Ignoring unsafe software power cap!\n");
+			dev_warn(&resource->acpi_dev->dev,
+				 "Ignoring unsafe software power cap!\n");
 			goto skip_unsafe_cap;
 		}
 
-- 
2.20.1



