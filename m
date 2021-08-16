Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4613ED617
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbhHPNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238297AbhHPNPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606DC6113D;
        Mon, 16 Aug 2021 13:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119567;
        bh=JhelQhtwuCqkEfrHns4q/vxEWd0Pk6rq+iGNKUCEvkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+w6cuMeekUUz/7Z7Rd/KGVSHTabPCM+zOL/+mUuAInx5L2cGNrNBcSdv/z8qihiV
         K1rVTkwj1YYxinVkkG+TXhaCOR4vMZ+oeYCF1n4tg227652IsGcpGqIi0e8W3c6C0I
         8fctcgLJZgbfviR5qr5qVr3O6mNtwLdQKzYOZa/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 059/151] platform/x86: pcengines-apuv2: Add missing terminating entries to gpio-lookup tables
Date:   Mon, 16 Aug 2021 15:01:29 +0200
Message-Id: <20210816125446.008986140@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9d7b132e62e41b7d49bf157aeaf9147c27492e0f ]

The gpiod_lookup_table.table passed to gpiod_add_lookup_table() must
be terminated with an empty entry, add this.

Note we have likely been getting away with this not being present because
the GPIO lookup code first matches on the dev_id, causing most lookups to
skip checking the table and the lookups which do check the table will
find a matching entry before reaching the end. With that said, terminating
these tables properly still is obviously the correct thing to do.

Fixes: f8eb0235f659 ("x86: pcengines apuv2 gpio/leds/keys platform driver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210806115515.12184-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pcengines-apuv2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/pcengines-apuv2.c b/drivers/platform/x86/pcengines-apuv2.c
index c37349f97bb8..d063d91db9bc 100644
--- a/drivers/platform/x86/pcengines-apuv2.c
+++ b/drivers/platform/x86/pcengines-apuv2.c
@@ -94,6 +94,7 @@ static struct gpiod_lookup_table gpios_led_table = {
 				NULL, 1, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_LINE_LED3,
 				NULL, 2, GPIO_ACTIVE_LOW),
+		{} /* Terminating entry */
 	}
 };
 
@@ -123,6 +124,7 @@ static struct gpiod_lookup_table gpios_key_table = {
 	.table = {
 		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_LINE_MODESW,
 				NULL, 0, GPIO_ACTIVE_LOW),
+		{} /* Terminating entry */
 	}
 };
 
-- 
2.30.2



