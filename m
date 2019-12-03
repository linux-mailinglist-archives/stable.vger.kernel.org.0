Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42679111E7B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfLCWxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbfLCWxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ECF12053B;
        Tue,  3 Dec 2019 22:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413611;
        bh=7QflUn8NJxwfu7Hkt2g5UkU81Lbjg82NbTyERgjD6c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUZbS1m+R7+Qt2eYJq3eHRF6P5A4vbEn/UONcLYVS+N9U5V7q+eXfkwXyiwLVRJnW
         TfEMy49J5CTMDAH/sBw63/GuQEUKRLW1jaE7T2oMs8OJEeLSyigfwfKOSimKgUb3Jh
         Lg5OpogkDLe4UzR37RLF/9YuOvPIpm7tKMYjL+8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/321] net: marvell: fix a missing check of acpi_match_device
Date:   Tue,  3 Dec 2019 23:34:20 +0100
Message-Id: <20191203223437.212729545@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 92ee77d148bf06d8c52664be4d1b862583fd5c0e ]

When acpi_match_device fails, its return value is NULL. Directly using
the return value without a check may result in a NULL-pointer
dereference. The fix checks if acpi_match_device fails, and if so,
returns -EINVAL.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1cc0e8fda4d5e..a50977ce40766 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5132,6 +5132,8 @@ static int mvpp2_probe(struct platform_device *pdev)
 	if (has_acpi_companion(&pdev->dev)) {
 		acpi_id = acpi_match_device(pdev->dev.driver->acpi_match_table,
 					    &pdev->dev);
+		if (!acpi_id)
+			return -EINVAL;
 		priv->hw_version = (unsigned long)acpi_id->driver_data;
 	} else {
 		priv->hw_version =
-- 
2.20.1



