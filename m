Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4953C3853
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhGJXyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhGJXxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5480461361;
        Sat, 10 Jul 2021 23:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961057;
        bh=Kr5HoqsE5MPFdwwLrEQmw5vIHfZj7/DGPLKFuD6t3uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpTpr7ATEMeO2NVw2mneYwrmUONwVW5vu7m7vp0G6AySed0kMmbZBu/plBJwgCWh/
         y2MlWX4joKSI0GmtEZMbCW8VBliGSIjjDeCDBb9cDxV4T3ctMItptTRAzUED4i8131
         6LEPj+sS8rrb4TS096BgLmj/sQ5vylpMIeyz1/LORys0EBEo+PuAGXVUD7Em5i7zRE
         gWomf+YUOEklOWAIhQvM//bU/E+0hiOc1429gBOt64gPxvlepy4bMXFibaU3zafIjK
         z5z00evHC9GMf0H5L2osz2yDO4d69BJ9abILekjovxHMckuzq20Fa2tAiGcCmh3yef
         9G++6vx3zGdbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liguang Zhang <zhangliguang@linux.alibaba.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/37] ACPI: AMBA: Fix resource name in /proc/iomem
Date:   Sat, 10 Jul 2021 19:50:09 -0400
Message-Id: <20210710235016.3221124-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liguang Zhang <zhangliguang@linux.alibaba.com>

[ Upstream commit 7718629432676b5ebd9a32940782fe297a0abf8d ]

In function amba_handler_attach(), dev->res.name is initialized by
amba_device_alloc. But when address_found is false, dev->res.name is
assigned to null value, which leads to wrong resource name display in
/proc/iomem, "<BAD>" is seen for those resources.

Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_amba.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_amba.c b/drivers/acpi/acpi_amba.c
index 49b781a9cd97..ab8a4e0191b1 100644
--- a/drivers/acpi/acpi_amba.c
+++ b/drivers/acpi/acpi_amba.c
@@ -76,6 +76,7 @@ static int amba_handler_attach(struct acpi_device *adev,
 		case IORESOURCE_MEM:
 			if (!address_found) {
 				dev->res = *rentry->res;
+				dev->res.name = dev_name(&dev->dev);
 				address_found = true;
 			}
 			break;
-- 
2.30.2

