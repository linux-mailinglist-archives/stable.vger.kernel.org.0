Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25C73C38B5
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhGJXzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232681AbhGJXy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B72613F3;
        Sat, 10 Jul 2021 23:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961096;
        bh=Kr5HoqsE5MPFdwwLrEQmw5vIHfZj7/DGPLKFuD6t3uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg6dTszqYKK7MoqMiYm5eoL2Aa15wqQ+XxGCmyvGxaTbGAau1hPrk9uxKHOzo3Gzv
         re/7GL9pmq5DkP3QEBIcKnkID4ekOIO4Aa19L+r9/2M6ZYdT3lxYSIhLC/M90MeZgi
         NbONtkVyN+ZnB+xfRu1ya0VsIlV1jjFqfZhTZEKQvJl0uqAl6Y6RYl4ioloLH+A905
         p0Yp58DckWCcFAlQiErD8WFEKtrA+Lo4OzX2aVWHcG1kJya3t+L0ISkhUtbePTXCUR
         rc0j06u5EFNyCNIkQluJ9zazx8HC0cPrVJ4m6iq7H4n4azHucIpTtbbh4eTMzrkCEg
         Zy1F3wOsIGrOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liguang Zhang <zhangliguang@linux.alibaba.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/28] ACPI: AMBA: Fix resource name in /proc/iomem
Date:   Sat, 10 Jul 2021 19:51:02 -0400
Message-Id: <20210710235107.3221840-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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

