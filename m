Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B33C5570
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355718AbhGLIKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353650AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0665E61437;
        Mon, 12 Jul 2021 07:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076589;
        bh=AoS07RgjTi3ijqRjXt5Qt0J7M7/4IUlk3SGXWrQDLEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kngUmtsTiVXZQKMiDo6bRKezY5R7r32WT0Pov1d8PjPOwD1u6zHzmhQWz63TuVc5t
         Hk0M0xGkLQRF0Umls0muSZogNbSO2f8oH7lTQKAAlvxvx3TJc8UAtNAS6Hl8g6mP77
         84bO+n+xPpYoL0ZXrt6eLCQuyRG8rIvIr4wBnp2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Duong <qhuyduong@hotmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 701/800] eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
Date:   Mon, 12 Jul 2021 08:12:04 +0200
Message-Id: <20210712061041.372473654@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 3f6ee1c095156a74ab2df605af13020f1ce3e600 ]

device_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: db15d73e5f0e ("eeprom: idt_89hpesx: Support both ACPI and OF probing")
Cc: Huy Duong <qhuyduong@hotmail.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210607221757.81465-1-andy.shevchenko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/idt_89hpesx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 81c70e5bc168..45a61a1f9e98 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1161,6 +1161,7 @@ static void idt_get_fw_data(struct idt_89hpesx_dev *pdev)
 	else /* if (!fwnode_property_read_bool(node, "read-only")) */
 		pdev->eero = false;
 
+	fwnode_handle_put(fwnode);
 	dev_info(dev, "EEPROM of %d bytes found by 0x%x",
 		pdev->eesize, pdev->eeaddr);
 }
-- 
2.30.2



