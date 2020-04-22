Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EC51B40C2
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgDVKrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgDVKP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF1D02070B;
        Wed, 22 Apr 2020 10:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550529;
        bh=pPR3E/+TEmW7X9ElB0tBqcMc5d+em6cDWmEOV6tWQKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RX8xbtVPTEt0Mzv/rUv+u02H9IKWqFNv5/ttlyYhEDAETrhMj8q9laMfiVU3/Ovmp
         LcgEwDthexk1tMHpBTFDDco2OwGIEBKTtCAghDyjH00dQ0pnIY3b0lyJd/Kye878KX
         WDd0AK52JHSdUgTRKxaqWAuQ5ELLKVDfMRdZtOWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffery Miller <jmiller@neverware.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/64] power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Compute Sticks.
Date:   Wed, 22 Apr 2020 11:57:35 +0200
Message-Id: <20200422095022.009950514@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffery Miller <jmiller@neverware.com>

[ Upstream commit e42fe5b29ac07210297e75f36deefe54edbdbf80 ]

The Intel Compute Stick `STK1A32SC` can have a system vendor of
"Intel(R) Client Systems".
Broaden the Intel Compute Stick DMI checks so that they match "Intel
Corporation" as well as "Intel(R) Client Systems".

This fixes an issue where the STK1A32SC compute sticks were still
exposing a battery with the existing blacklist entry.

Signed-off-by: Jeffery Miller <jmiller@neverware.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index ab0b6e78ca02a..157cf5ec6b023 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -718,14 +718,14 @@ static const struct dmi_system_id axp288_fuel_gauge_blacklist[] = {
 	{
 		/* Intel Cherry Trail Compute Stick, Windows version */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "STK1AW32SC"),
 		},
 	},
 	{
 		/* Intel Cherry Trail Compute Stick, version without an OS */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "STK1A32SC"),
 		},
 	},
-- 
2.20.1



