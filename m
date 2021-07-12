Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22463C4AA8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhGLGxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240243AbhGLGuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D6860FD8;
        Mon, 12 Jul 2021 06:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072485;
        bh=AoS07RgjTi3ijqRjXt5Qt0J7M7/4IUlk3SGXWrQDLEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPb5GWGS1GB6sXcKh7Jq5mNMNX59+8ryUtPh04MoZ6oDgIAMMqkGRmPK8q+aKz++C
         29s3xIz/EDvfRuDUM80S1Zf+QcL4UTyt2sBrtqTcAJ0ZxUJl9fhKWtO/b1M/yCzMbx
         lP3TzeA+mhyABb9i7ooCHgfRiy/Gt0bxDeb/5PYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Duong <qhuyduong@hotmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 512/593] eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
Date:   Mon, 12 Jul 2021 08:11:12 +0200
Message-Id: <20210712060948.310595494@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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



