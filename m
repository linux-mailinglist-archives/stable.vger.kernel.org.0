Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA05431E1E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhJRN54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233513AbhJRNz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210DC61A0A;
        Mon, 18 Oct 2021 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564419;
        bh=B9OPdaySnRMGvm5T8Nz/ZoMUNOqReRoCZ5ID4bBQF2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD8XYr3nvV+cBCVxmX7r8ipHmlCnWL2HO7hFCnYUjCZstvbrpzziCAQBi6IQdq9qm
         nMA8l2juVJKPY3lA0LaYXjLQoTYFBvFctESM+drqRydJ8yZ0/4n6n1j/H2QlWzkxNH
         f9q9rkZxAJImpy+zOiOR0rkrzqsnIRcvA4Kd6+YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.14 083/151] eeprom: 93xx46: fix MODULE_DEVICE_TABLE
Date:   Mon, 18 Oct 2021 15:24:22 +0200
Message-Id: <20211018132343.385955308@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f42752729e2068a92c7d8b576d0dbbc9c1464149 upstream.

The newly added SPI device ID table does not work because the
entry is incorrectly copied from the OF device table.

During build testing, this shows as a compile failure when building
it as a loadable module:

drivers/misc/eeprom/eeprom_93xx46.c:424:1: error: redefinition of '__mod_of__eeprom_93xx46_of_table_device_table'
MODULE_DEVICE_TABLE(of, eeprom_93xx46_of_table);

Change the entry to refer to the correct symbol.

Fixes: 137879f7ff23 ("eeprom: 93xx46: Add SPI device ID table")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211014153730.3821376-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -421,7 +421,7 @@ static const struct spi_device_id eeprom
 	  .driver_data = (kernel_ulong_t)&microchip_93lc46b_data, },
 	{}
 };
-MODULE_DEVICE_TABLE(of, eeprom_93xx46_of_table);
+MODULE_DEVICE_TABLE(spi, eeprom_93xx46_spi_ids);
 
 static int eeprom_93xx46_probe_dt(struct spi_device *spi)
 {


