Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927B33C4FAC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbhGLH1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345288AbhGLHZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4445F6136D;
        Mon, 12 Jul 2021 07:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074528;
        bh=p8bNnxJwgHMycf5P+nl2Gg916UtFZkNQDNpHCCG8iMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQq0GXc2DiAOjDp9e9ej+kIyoG7QgGiD9hotgTHWs/2FoxVcd3dk4GFJEzlrwEzUT
         8Z8uOORNIejAh64wF0Uq5ePzorQXHM5SjwCmmtb1MiXUn3V893yLMAv9j+UktW2Yry
         ZzFy/V+c0qT6hTMd3WXqGmlTGQSWN14l8vGtA+wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Duong <qhuyduong@hotmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 609/700] eeprom: idt_89hpesx: Restore printing the unsupported fwnode name
Date:   Mon, 12 Jul 2021 08:11:32 +0200
Message-Id: <20210712061040.744655002@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit e0db3deea73ba418bf5dc21f5a4e32ca87d16dde ]

When iterating over child firmware nodes restore printing the name of ones
that are not supported.

While at it, refactor loop body to clearly show that we stop at the first match.

Fixes: db15d73e5f0e ("eeprom: idt_89hpesx: Support both ACPI and OF probing")
Cc: Huy Duong <qhuyduong@hotmail.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210607221757.81465-2-andy.shevchenko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/idt_89hpesx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 45a61a1f9e98..3e4a594c110b 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1126,11 +1126,10 @@ static void idt_get_fw_data(struct idt_89hpesx_dev *pdev)
 
 	device_for_each_child_node(dev, fwnode) {
 		ee_id = idt_ee_match_id(fwnode);
-		if (!ee_id) {
-			dev_warn(dev, "Skip unsupported EEPROM device");
-			continue;
-		} else
+		if (ee_id)
 			break;
+
+		dev_warn(dev, "Skip unsupported EEPROM device %pfw\n", fwnode);
 	}
 
 	/* If there is no fwnode EEPROM device, then set zero size */
-- 
2.30.2



